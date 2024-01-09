//
//  GoalEditView.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/09.
//

import UIKit
import SnapKit

protocol GoalEidtDelegate: AnyObject {
    func saveGoal(goal: String)
}
final class GoalEditView: UIViewController {
    weak var delegate: GoalEidtDelegate?
    
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    private let contentsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        return view
    }()
    private let backButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 12
        button.backgroundColor = .jadaLightGray
        button.setImage(image, for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaLargeTitleFont
        label.textColor = .jadaDarkGreen
        label.text = "목표 작성"
        return label
    }()
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = .jadaTitleFont
        textField.textColor = .black
        textField.placeholder = "30자 제한"
        return textField
    }()
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .jadaTitleFont
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 15
        button.backgroundColor = .jadaLightGray
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configButtons()
        configTextField()
    }
    private func configTextField() {
        textField.delegate = self
    }
    private func configButtons() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            delegate?.saveGoal(goal: textField.text ?? "")
        }
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    private func setUI(){
        view.addSubViews([dimView, contentsView])
        contentsView.addSubViews([backButton, titleLabel, textField, confirmButton])
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.3)
            make.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(24)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
}

extension GoalEditView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if text != "" {
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = .jadaMainGreen
        } else {
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = .jadaLightGray
        }
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        guard text.count <= 40 else { return false }

        return true
    }
}
