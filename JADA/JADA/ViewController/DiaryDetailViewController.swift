//
//  DiaryDetailViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/26.
//

import UIKit
import SnapKit

final class DiaryDetailViewController: UIViewController {
    private let diary: Diary
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
        let textView = JadaTextView()
        textView.backgroundColor = .jadaNoteBackground
        textView.font = .jadaNonBoldTitleFont
        textView.textColor = .black
        textView.isEditable = false
        return textView
    }()
    private let buttonView: UIView = UIView()
    private let editButton: JadaFilledButton = JadaFilledButton(title: "수정", background: .jadaMainGreen)
    private let deleteButton: JadaFilledButton = JadaFilledButton(title: "삭제", background: .jadaDangerRed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .jadaNoteBackground
        configNavigation(title: "일기 Detail")
        setUI()
        setData()
    }
    
    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setData() {
        iconImageView.image = UIImage(named: diary.emotion.rawValue)
        dateLabel.text = Date(timeIntervalSince1970: diary.createdDate).toString()
        contentTextView.text = diary.contents
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
