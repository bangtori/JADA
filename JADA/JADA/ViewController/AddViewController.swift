//
//  AddViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/12.
//

import UIKit
import SnapKit

final class AddViewController: UIViewController {
    private let diary: Diary?
    private let isDetail: Bool
    
    private let textViewPlaceHolder = "일기 입력"
    private var selectedDate = Date()
    private let dateView: UIView = UIView()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaLargeTitleFont
        label.textColor = .black
        return label
    }()
    private let dateEditButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .jadaMainGreen
        return button
    }()
    private let contentTextView: JadaTextView = {
        let jdTextView = JadaTextView()
        let textview = jdTextView.textview
        textview.font = .jadaNonBoldTitleFont
        textview.textColor = .lightGray
        return jdTextView
    }()
    private let saveButton: JadaFilledButton = JadaFilledButton(title: "저장", background: .jadaGray)

    init(diary: Diary? = nil, isDetail: Bool = false) {
        self.diary = diary
        self.isDetail = isDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavigation(title: "일기 작성")
        setUI()
        configData()
        configTextView()
        view.tappedDismissKeyboard()
        configButtons()
    }
    private func configButtons() {
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(tappedSaveButton), for: .touchUpInside)
        dateEditButton.addTarget(self, action: #selector(tappedDateEditButton), for: .touchUpInside)
    }
    private func configTextView() {
        contentTextView.textview.delegate = self
    }
    private func configData() {
        if let diary = diary {
            dateLabel.text = Date(timeIntervalSince1970: diary.date).toString()
            contentTextView.textview.text = diary.contents
            contentTextView.textview.textColor = .black
        } else {
            dateLabel.text = selectedDate.toString()
            contentTextView.textview.text = textViewPlaceHolder
        }
    }
    @objc private func tappedDateEditButton(_ sender: UIButton) {
        showDatePicker()
    }
    @objc private func tappedSaveButton(_ sender: UIButton) {
        let apiSevice = ClovaApiService()
        guard let contents = contentTextView.textview.text else { return }
        apiSevice.fetchData(text: contentTextView.textview.text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let diary = diary {
                    FirestoreService.shared.deleteDocument(collectionId: .diary, documentId: diary.id) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(_):
                            saveDiary(data: data, contents: contents)
                        case .failure(let error):
                            print("Error: 데이터 저장 실패\n\(error)")
                            showAlert(message: "데이터 저장에 실패하였습니다. 다시 시도해주세요.", title: "데이터 저장 실패")
                            return
                        }
                    }
                } else {
                    saveDiary(data: data, contents: contents)
                }
            case .failure(_):
                showAlert(message: "감정 분석에 실패하였습니다.",title: "데이터 저장 실패") {
                    return
                }
            }
        }
    }
    private func saveDiary(data: SentimentModel, contents: String) {
        guard let userId = UserDefaultsService.shared.getData(key: .userId) as? String else {
            print("Error: UserDefaults UserId 가져오기 실패")
            showAlert(message: "유저정보를 가져오는데 실패했습니다. 다시 로그인해주세요.", title: "유저 정보 가져오기 실패") {
                UserDefaultsService.shared.removeAll()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(SignInViewController(), animated: true)
            }
            return
        }
        guard let emotion = getEmotion(resultString: data.document.sentiment) else {
            print("Error: 데이터 변환 실패")
            showAlert(message: "감정 데이터 변환에 실패하였습니다. 다시 시도해주세요.", title: "데이터 변환 실패")
            return
        }
        let newDiary = Diary(date: selectedDate.timeIntervalSince1970, writerId: userId, contents: contents, emotion: emotion)
        FirestoreService.shared.saveDocument(collectionId: .diary, documentId: newDiary.id, data: newDiary) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                updateCountData(emotion: emotion, userId: userId)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let viewController = ResultViewController(sentiment: data, diary: newDiary, isDetail: isDetail)
                    viewController.hideNavigationBackButton()
                    navigationController?.pushViewController(viewController, animated: true)
                }
            case .failure(let error):
                print("Error: 데이터 저장 실패")
                showAlert(message: "데이터 저장에 실패하였습니다. 다시 시도해주세요.\n\(error)", title: "데이터 저장 실패")
                return
            }
        }
    }
    
    private func updateCountData(emotion: Emotion, userId: String) {
        if let diary = diary {
            guard let currentPostCount =  UserDefaultsService.shared.getData(key: .postCount) as? Int else { return }
            guard let currrentPositiveCount = UserDefaultsService.shared.getData(key: .positiveCount) as? Int else { return }
            UserDefaultsService.shared.updateData(key: .postCount, value:currentPostCount - 1)
            if diary.emotion == .positive {
                UserDefaultsService.shared.updateData(key: .postCount, value:currrentPositiveCount - 1)
            }
        }
        UserDefaultsService.shared.updatePost(postResult: emotion)
        FirestoreService.shared.updateDocument(collectionId: .users, documentId: userId, field: "postCount", data: UserDefaultsService.shared.getData(key: .postCount) as? Int) { _ in }
        if emotion == .positive {
            FirestoreService.shared.updateDocument(collectionId: .users, documentId: userId, field: "positiveCount", data: UserDefaultsService.shared.getData(key: .positiveCount) as? Int) { _ in }
        }
    }
    
    private func getEmotion(resultString: String) -> Emotion? {
        switch resultString {
        case "positive":
            return .positive
        case "neutral":
            return .neutral
        case "negative":
            return .negative
        default:
            return nil
        }
    }
    
    private func setUI(){
        view.addSubViews([dateView, contentTextView, saveButton])
        dateView.addSubViews([dateLabel, dateEditButton])
        
        dateView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        dateEditButton.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing)
            make.top.bottom.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview()
            make.width.equalTo(dateEditButton.snp.height)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(50)
            make.leading.trailing.equalTo(contentTextView)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
    }
}

extension AddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
        checkIsEnableButton()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        checkIsEnableButton()
        return true
    }
    
    private func checkIsEnableButton() {
        if !contentTextView.textview.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && contentTextView.textview.text != textViewPlaceHolder {
            saveButton.isEnabled = true
            saveButton.backgroundColor = .jadaMainGreen
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .jadaGray
        }
    }
}

// MARK: - DatePicker 관련
extension AddViewController {
    private func showDatePicker() {
        let alert = UIAlertController(title: "일기 날짜 선택", message: "", preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.date = selectedDate
        datePicker.locale = Locale(identifier: "ko_KR")
                
        let ok = UIAlertAction(title: "선택 완료", style: .cancel) { [weak self] action in
            guard let self = self else { return }
            selectedDate = datePicker.date
            dateLabel.text = selectedDate.toString()
        }
                        
        alert.addAction(ok)
                
        let vc = UIViewController()
        vc.view = datePicker
                
        alert.setValue(vc, forKey: "contentViewController")
                
        present(alert, animated: true)
    }
}
