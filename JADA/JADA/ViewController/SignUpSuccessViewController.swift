//
//  SignUpSuccessViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/16.
//

import UIKit
import SnapKit

final class SignUpSuccessViewController: UIViewController {
    private let contentView = UIView()
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaTitleFont
        label.textColor = .jadaMainGreen
        label.textAlignment = .center
        label.text = "회원가입 성공!"
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaTitleFont
        label.textColor = .jadaGray
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "회원가입 해주셔서 감사합니다.\n로그인 후 이용해주세요."
        return label
    }()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인 하러가기 >", for: .normal)
        button.titleLabel?.font = .jadaTitleFont
        button.setTitleColor(.jadaMainGreen, for: .normal)
        button.setTitleColor(.clear, for: .highlighted)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        configButtons()
    }
    private func configButtons(){
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
    }
    @objc private func tappedLoginButton(_ sender: UIBarButtonItem) {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    private func setUI() {
        view.addSubview(contentView)
        contentView.addSubViews([logoImageView, titleLabel, subTitleLabel, loginButton])
        
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
