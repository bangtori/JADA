//
//  DiaryDetailViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/26.
//

import UIKit
import SnapKit

final class DiaryDetailViewController: UIViewController {
    private var diary: Diary
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaLargeTitleFont
        label.textColor = .black
        return label
    }()
    private let contentTextView: JadaTextView = {
        let jdTextView = JadaTextView()
        let textview = jdTextView.textview
        textview.backgroundColor = .jadaNoteBackground
        textview.font = .jadaNonBoldTitleFont
        textview.textColor = .black
        textview.isEditable = false
        return jdTextView
    }()
    private let buttonView: UIView = UIView()
    private let editButton: JadaFilledButton = JadaFilledButton(title: "수정", background: .jadaMainGreen)
    private let deleteButton: JadaFilledButton = JadaFilledButton(title: "삭제", background: .jadaDangerRed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .jadaNoteBackground
        configNavigation(title: "일기 Detail")
        setUI()
        configData()
        configButtons()
        configNotificationCenter()
    }
    
    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func editData(diary: Diary) {
        self.diary = diary
        configData()
        
        view.layoutIfNeeded()
    }
    
    private func configNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDetailDismissed), name: NSNotification.Name("DetailDismissed"), object: nil)
    }
    
    @objc private func handleDetailDismissed(_ notification: Notification) {
        if let data = notification.object as? Diary {
            editData(diary: data)
        }
    }
    
    private func configButtons() {
        editButton.addTarget(self, action: #selector(tappedEditButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(tappedDeleteButton), for: .touchUpInside)
    }
    
    @objc private func tappedEditButton(_ sender: UIButton) {
        let viewController = AddViewController(diary: diary, isDetail: true)
        navigationController?.pushViewController(viewController, animated: true)
    }
    @objc private func tappedDeleteButton(_ sender: UIButton) {
        showAlert(message: "\(Date(timeIntervalSince1970: diary.createdDate).toString()) 일기를 삭제합니다.", title: "일기 삭제", isCancelButton: true, yesButtonTitle: "삭제") { [weak self] in
            guard let self = self else { return }
            FirestoreService.shared.deleteDocument(collectionId: .diary, documentId: diary.id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    print("\(diary.id) 삭제 성공")
                    UserDefaultsService.shared.deletePost(deletePostEmotion: diary.emotion)
                    navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Error: 데이터 삭제 실패\n\(error)")
                    showAlert(message: "해당 일기를 삭제하는데 실패하였습니다. 다시 시도해주세요. \n오류가 계속될 시 문의해주세요.", title: "삭제 실패")
                }
            }
        }
    }
    
    private func configData() {
        iconImageView.image = UIImage(named: diary.emotion.rawValue)
        dateLabel.text = Date(timeIntervalSince1970: diary.createdDate).toString()
        contentTextView.textview.text = diary.contents
    }
    
    private func setUI() {
        view.addSubViews([iconImageView, dateLabel, contentTextView, buttonView])
        buttonView.addSubViews([editButton, deleteButton])
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(40)
            make.leading.trailing.equalTo(contentTextView)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
        editButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(editButton.snp.trailing).offset(10)
            make.width.equalTo(editButton)
        }
    }
}
