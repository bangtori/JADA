//
//  SignInViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/08.
//

import UIKit
import SnapKit

final class SignInViewController: UIViewController {
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let emailTextField: JadaTextField = JadaTextField(label: "Email")
    private let passwordTextField: JadaTextField = JadaTextField(label: "Password", isSecure: true)
    private let fetailDescription: UILabel = {
        let label = UILabel()
        label.font = .jadaCalloutFont
        label.textColor = .jadaDangerRed
        label.isHidden = true
        return label
    }()
    private let signInButton: JadaFilledButton = JadaFilledButton(title: "로그인")
    private let signUpButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.jadaGray, for: .normal)
        button.tintColor = .clear
        return button
    }()
    private let forgotFasswordButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.jadaGray, for: .normal)
        button.tintColor = .clear
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        configButtons()
    }
    
    private func configButtons() {
        signInButton.addTarget(self, action: #selector(tappedSignInButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(tappedSignUpButton), for: .touchUpInside)
        forgotFasswordButton.addTarget(self, action: #selector(tappedforgotFasswordButton), for: .touchUpInside)
    }
    
    private func setUI() {
        view.addSubViews([logoImage, emailTextField, passwordTextField, fetailDescription, signInButton, signUpButton, forgotFasswordButton])
        
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Screen.width * 0.5)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        
        fetailDescription.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.leading.trailing.equalTo(passwordTextField)
            make.height.equalTo(fetailDescription.font.pointSize)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(fetailDescription.snp.bottom).offset(10)
            make.leading.trailing.equalTo(fetailDescription)
            make.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(10)
            make.leading.equalTo(signInButton)
        }
        
        forgotFasswordButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton)
            make.trailing.equalTo(signInButton)
        }
    }
}

// MARK: - Button
extension SignInViewController {
    @objc private func tappedSignInButton(_ sender: UIButton) {
        sender.tappedAnimation()
        if validate() {
            fetailDescription.isHidden = true
            
        } else {
            fetailDescription.isHidden = false
            fetailDescription.text = "이메일 형식을 지켜주세요."
        }
    }
    @objc private func tappedSignUpButton(_ sender: UIButton) {
        let viewController = SignUpViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    @objc private func tappedforgotFasswordButton(_ sender: UIButton) {
        print("비밀번호 찾기")
    }
    
    private func validate() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        guard let email = emailTextField.textField.text else { return false }
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
