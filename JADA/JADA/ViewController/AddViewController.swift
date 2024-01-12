//
//  AddViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/12.
//

import UIKit
import SnapKit

final class AddViewController: UIViewController {
    
    private let textViewPlaceHolder = "일기 입력"
    
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
        let textView = JadaTextView()
        textView.font = .jadaNonBoldTitleFont
        textView.textColor = .lightGray
        return textView
    }()
    private let saveButton: JadaFilledButton = JadaFilledButton(title: "저장", background: .jadaGray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavigation(title: "Add")
        setUI()
        configData()
        configTextView()
        view.tappedDismissKeyboard()
        configButtons()
    }
    private func configButtons() {
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(tappedSaveButton), for: .touchUpInside)
    }
    private func configTextView() {
        contentTextView.delegate = self
    }
    private func configData() {
        dateLabel.text = Date().toString()
        contentTextView.text = textViewPlaceHolder
    }
    @objc private func tappedSaveButton(_ sender: UIButton) {
        sender.tappedAnimation()
        print("저장")
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
        if !contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && contentTextView.text != textViewPlaceHolder {
            saveButton.isEnabled = true
            saveButton.backgroundColor = .jadaMainGreen
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .jadaGray
        }
    }
}
