//
//  SignUpViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/08.
//

import UIKit
import SnapKit

final class SignUpViewController: UIViewController {
    private let emailTextField: JadaTextField = JadaTextField(label: "Email")
    private let emailWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "Email 형식을 지켜주세요."
        label.font = .jadaCalloutFont
        label.textColor = .jadaDangerRed
        label.isHidden = true
        return label
    }()
    private let passwordTextField: JadaTextField = JadaTextField(label: "Password", isSecure: true)
    private let passwordWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "8자 이상 영문 + 숫자 조합으로 입력해주세요."
        label.font = .jadaCalloutFont
        label.textColor = .jadaDangerRed
        label.isHidden = true
        return label
    }()
    private let passwordCheckTextField: JadaTextField = JadaTextField(label: "Password", isSecure: true)
    private let passwordCheckWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호와 일치하지 않습니다."
        label.font = .jadaCalloutFont
        label.textColor = .jadaDangerRed
        label.isHidden = true
        return label
    }()
    private let nicknameTextField: JadaTextField = JadaTextField(label: "Nickname(8자 이하)", maxLength: 8)
    private let signUpButton: JadaFilledButton = JadaFilledButton(title: "회원가입")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavigation(title: "회원가입")
        setUI()
        configButtons()
    }

    private func configButtons() {
        signUpButton.addTarget(self, action: #selector(tappedSignUpButton), for: .touchUpInside)
    }
    
    @objc private func tappedSignUpButton(_ sender: UIButton) {
        sender.tappedAnimation()
        print("회원가입")
    }
    private func setUI() {
        view.addSubViews([emailTextField, emailWarningLabel, passwordTextField, passwordWarningLabel, passwordCheckTextField, passwordCheckWarningLabel, nicknameTextField, signUpButton])
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
        emailWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(emailWarningLabel.font.pointSize)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailWarningLabel.snp.bottom).offset(30)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        passwordWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(emailWarningLabel.font.pointSize)
        }
        
        passwordCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordWarningLabel.snp.bottom).offset(30)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        passwordCheckWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckTextField.snp.bottom).offset(5)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(emailWarningLabel.font.pointSize)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckWarningLabel.snp.bottom).offset(30)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.leading.trailing.equalTo(nicknameTextField)
            make.height.equalTo(50)
        }
    }
}
