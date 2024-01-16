//
//  JadaTextField.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/08.
//

import UIKit
import SnapKit

protocol JadaTextFieldDelegate: AnyObject {
    func validate(_ sender: JadaTextField)
}

final class JadaTextField: UIView {
    private var maxLength: Int
    weak var delegate: JadaTextFieldDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaCalloutFont
        label.textColor = .jadaGray
        return label
    }()
    let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    private let removeButton: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        let image = UIImage(systemName: "x.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .jadaMainGreen
        button.isHidden = true
        return button
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .jadaGray
        return view
    }()

    init(frame: CGRect = .zero, label: String, maxLength: Int = 0, isSecure: Bool = false) {
        self.titleLabel.text = label
        self.maxLength = maxLength
        self.textField.isSecureTextEntry = isSecure
        super.init(frame: frame)
        setUI()
        configTextField()
        configButtons()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configTextField() {
        textField.delegate = self
    }
    
    private func configButtons() {
        removeButton.addTarget(self, action: #selector(tappedRemoveButton), for: .touchUpInside)
    }
    
    @objc private func tappedRemoveButton(_ sender: UIButton) {
        textField.text = ""
        removeButton.isHidden = true
    }
    
    private func setUI() {
        addSubViews([titleLabel, textField, removeButton, lineView])
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        removeButton.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(textField.snp.centerY)
            make.width.equalTo(20)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(5)
            make.leading.trailing.equalTo(textField)
            make.height.equalTo(1)
        }
    }
}

extension JadaTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        removeButton.isHidden = false
        lineView.backgroundColor = .jadaMainGreen
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        removeButton.isHidden = true
        lineView.backgroundColor = .jadaGray
        delegate?.validate(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if maxLength == 0 {
            return true
        }
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard textField.text!.count < maxLength else { return false }
        return true
    }
}
