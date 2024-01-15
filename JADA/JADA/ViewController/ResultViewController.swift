//
//  ResultViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/15.
//

import UIKit
import SnapKit

final class ResultViewController: UIViewController {
    private let date: Date
    private let sentiment: SentimentModel
    private let contentsView: UIView = UIView()
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
    
    private let galleryButton = JadaIconLabelButtonView(label: "사진 앱에 저장", icon: UIImage(systemName: "camera.on.rectangle"), iconSize: 45, font: .jadaCalloutFont)
    private let instagramButton = JadaIconLabelButtonView(label: "인스타그램 공유", icon: UIImage(named: "instagram"), iconSize: 30, font: .jadaCalloutFont)
    
    init(sentiment: SentimentModel, date: Date) {
        self.sentiment = sentiment
        self.date = date
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
    }
    
    private func configNavigationBarButton() {
        let homeButton = UIBarButtonItem(title: "홈으로", style: .done, target: self, action: #selector(tappedHomeButton))
        homeButton.tintColor = .jadaMainGreen
        homeButton.accessibilityLabel = "홈으로 이동"
        navigationItem.rightBarButtonItem = homeButton
    }
    @objc private func tappedHomeButton(_ sender: UIBarButtonItem) {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    private func configData() {
        dateLabel.text = date.toString()
        var result: Emotion
        var resultLabelText = ""
        switch sentiment.document.sentiment {
        case "positive":
            result = .positive
            resultLabelText = "긍정 "
        case "negative":
            result = .negative
            resultLabelText = "부정 "
        case "neutral":
            result = .neutral
            resultLabelText = "중립 "
        default:
            result = .neutral
        }
        iconImageView.image = UIImage(named: result.rawValue)
        descriptionLabel.text = result.resultDescription
        resultLabelText += "\(sentiment.document.confidence.maxPercent)%"
        resultLabel.text = resultLabelText
    }
    private func setUI() {
        view.addSubview(contentsView)
        contentsView.addSubViews([dateLabel, iconImageView, resultLabel, descriptionLabel, galleryButton, instagramButton])
        
        contentsView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
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
        }
        galleryButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        instagramButton.snp.makeConstraints { make in
            make.top.equalTo(galleryButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
