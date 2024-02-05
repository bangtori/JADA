//
//  ImageSharedViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/02/01.
//

import UIKit
import SnapKit
import Photos

final class ImageSharedViewController: UIViewController {
    enum SharedType: String {
        case galley
        case instagram
    }
    private let sharedType: SharedType
    private let sharedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let saveButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = .jadaTitleFont
        configuration.attributedTitle = AttributedString("저장하기", attributes: titleContainer)
        configuration.imagePlacement = .leading
        configuration.image = UIImage(systemName: "square.and.arrow.down")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration)
        button.tintColor = .jadaDarkGreen
        return button
    }()
    private let instagramButtonView = UIView()
    private let instagramStoryButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = .jadaBoldBodyFont
        configuration.attributedTitle = AttributedString("스토리", attributes: titleContainer)
        configuration.imagePlacement = .top
        configuration.image = UIImage(named: "story")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration)
        button.tintColor = .black
        return button
    }()
    private let instagramFeedButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = .jadaBoldBodyFont
        configuration.attributedTitle = AttributedString("피드", attributes: titleContainer)
        configuration.imagePlacement = .top
        configuration.image = UIImage(named: "feed")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration)
        button.tintColor = .black
        return button
    }()
    
    init(sharedImage: UIImage, sharedType: SharedType) {
        self.sharedType = sharedType
        self.sharedImageView.image = sharedImage
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F4F4F4")
        setUI()
        configButton()
    }
    
    private func configButton() {
        saveButton.addTarget(self, action: #selector(tappedSaveButton), for: .touchUpInside)
    }
    
    @objc private func tappedSaveButton(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard status == .authorized, let image = sharedImageView.image else { return }
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { [weak self] _, error in
                    guard let self = self else { return }
                    if let error = error {
                        print("Error: 이미지 저장 실패\n\(error)")
                        showToast(message: "이미지 저장에 실패하였습니다.")
                        return
                    }
                    showToast(message: "이미지 저장 성공!")
                }
            }
        }
    }
    
    private func setUI() {
        if sharedType == .instagram {
            view.addSubViews([sharedImageView, instagramButtonView])
            instagramButtonView.addSubViews([instagramStoryButton, instagramFeedButton])
        } else {
            view.addSubViews([sharedImageView, saveButton])
        }
        
        sharedImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(sharedImageView.snp.width)
        }
        if sharedType == .instagram {
            instagramButtonView.snp.makeConstraints { make in
                make.top.equalTo(sharedImageView.snp.bottom).offset(30)
                make.centerX.equalToSuperview()
            }
            instagramStoryButton.snp.makeConstraints { make in
                make.top.leading.bottom.equalToSuperview()
            }
            instagramFeedButton.snp.makeConstraints { make in
                make.leading.equalTo(instagramStoryButton.snp.trailing).offset(30)
                make.top.trailing.bottom.equalToSuperview()
            }
        } else {
            saveButton.snp.makeConstraints { make in
                make.top.equalTo(sharedImageView.snp.bottom).offset(30)
                make.centerX.equalToSuperview()
            }
        }
    }
}
