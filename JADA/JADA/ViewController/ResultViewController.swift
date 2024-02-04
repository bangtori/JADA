//
//  ResultViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/15.
//

import UIKit
import SnapKit

final class ResultViewController: UIViewController {
    private let isDetail: Bool
    private let sentiment: SentimentModel
    private let diary: Diary
    private let contentsView: UIView = UIView()
    private let captureView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaLargeTitleFont
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaLargeTitleFont
        label.textColor = .jadaDarkGreen
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaBodyFont
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    private let buttonView = UIView()
    private let galleryButton = JadaIconLabelButtonView(label: "사진 앱에 저장", icon: UIImage(systemName: "camera.on.rectangle"), iconSize: 45, font: .jadaCalloutFont)
    private let instagramButton = JadaIconLabelButtonView(label: "인스타그램 공유", icon: UIImage(named: "instagram"), iconSize: 30, font: .jadaCalloutFont)
    
    init(sentiment: SentimentModel, diary: Diary, isDetail: Bool) {
        self.isDetail = isDetail
        self.sentiment = sentiment
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavigation(title: "일기 결과")
        setUI()
        configData()
        configNavigationBarButton()
        configButtons()
    }
    
    private func configButtons() {
        let galleryButtonGesture = UITapGestureRecognizer(target: self, action: #selector(tappedGalleryButton))
        galleryButton.addGestureRecognizer(galleryButtonGesture)
        let instagramButtonGesture = UITapGestureRecognizer(target: self, action: #selector(tappedInstagramButton))
        instagramButton.addGestureRecognizer(instagramButtonGesture)
    }
    
    private func configNavigationBarButton() {
        if isDetail {
            let backButton = UIBarButtonItem(title: "디테일로", style: .done, target: self, action: #selector(tappedBarButton))
            backButton.tintColor = .jadaMainGreen
            backButton.accessibilityLabel = "디테일뷰로 이동"
            navigationItem.rightBarButtonItem = backButton
        } else {
            let homeButton = UIBarButtonItem(title: "홈으로", style: .done, target: self, action: #selector(tappedBarButton))
            homeButton.tintColor = .jadaMainGreen
            homeButton.accessibilityLabel = "홈으로 이동"
            navigationItem.rightBarButtonItem = homeButton
        }
    }
    
    private func configData() {
        dateLabel.text = Date(timeIntervalSince1970: diary.date).toString()
        var resultLabelText = ""
        switch diary.emotion {
        case .positive:
            resultLabelText = "긍정 "
        case .negative:
            resultLabelText = "부정 "
        case .neutral:
            resultLabelText = "중립 "
        }
        iconImageView.image = UIImage(named: diary.emotion.rawValue)
        descriptionLabel.text = diary.emotion.resultDescription
        resultLabelText += "\(sentiment.document.confidence.maxPercent)%"
        resultLabel.text = resultLabelText
    }
    private func setUI() {
        view.addSubview(contentsView)
        contentsView.addSubViews([captureView, buttonView])
        captureView.addSubViews([dateLabel, iconImageView, resultLabel, descriptionLabel])
        buttonView.addSubViews([galleryButton, instagramButton])
        
        contentsView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        captureView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.trailing.equalTo(dateLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(iconImageView.snp.width)
        }
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(captureView.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalToSuperview()
        }
        galleryButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        instagramButton.snp.makeConstraints { make in
            make.top.equalTo(galleryButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Button 이벤트
extension ResultViewController {
    @objc private func tappedBarButton(_ sender: UIBarButtonItem) {
        if isDetail {
            NotificationCenter.default.post(name: NSNotification.Name("DetailDismissed"), object: diary)
            guard let viewControllers = navigationController?.viewControllers else { return }
            
            if viewControllers.count >= 3 {
                let destinationViewController = viewControllers[viewControllers.count - 3]
                navigationController?.popToViewController(destinationViewController, animated: true)
            }
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc private func tappedGalleryButton(_ sender: UITapGestureRecognizer) {
        UIGraphicsBeginImageContextWithOptions(captureView.frame.size, false, UIScreen.main.scale)
        captureView.drawHierarchy(in: captureView.frame, afterScreenUpdates: true)
        guard let captureImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        let modalController =  ImageSharedViewController(sharedImage: captureImage)
        let navigationController = UINavigationController(rootViewController: modalController)
        navigationController.modalPresentationStyle = .formSheet
        
        modalController.navigationItem.title = "결과 저장"
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDoneButton))
        doneButton.tintColor = .jadaDarkGreen
        modalController.navigationItem.rightBarButtonItem = doneButton
        self.present(navigationController, animated: true)
    }
    
    @objc private func tappedDoneButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
