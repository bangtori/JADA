//
//  DiaryListCell.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/09.
//

import UIKit
import SnapKit

final class DiaryListCell: UITableViewCell {
    static let identifier: String = "DiaryCell"
    
    private let background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#ECEDE5")
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let positivePercentLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaCalloutFont
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaTitleFont
        label.textColor = .black
        return label
    }()
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaBodyFont
        label.textColor = .black
        return label
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .jadaDarkGreen
        return view
    }()
    private let editButton: JadaIconLabelButtonView = JadaIconLabelButtonView(label: "Edit", icon: UIImage(systemName: "square.and.pencil"), iconSize: 25)
    private let deleteButton: JadaIconLabelButtonView = JadaIconLabelButtonView(label: "Delete", icon: UIImage(systemName: "trash"), iconSize: 25)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        configButtons()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        positivePercentLabel.text = ""
        dateLabel.text = ""
        contentsLabel.text = ""
    }
    
    func configData(icon: UIImage?, positivePercent: Int, dateString: String, contents: String) {
        iconImageView.image = icon
        positivePercentLabel.text = "\(positivePercent)%"
        dateLabel.text = dateString
        contentsLabel.text = contents
    }
    
    private func configButtons() {
        let EditButtontapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedEditButton))
        editButton.addGestureRecognizer(EditButtontapGesture)
        
        let DeleteButtontapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedDeleteButton))
        deleteButton.addGestureRecognizer(DeleteButtontapGesture)
    }
    
    @objc private func tappedEditButton(sender: UITapGestureRecognizer) {
        print("editbuttton")
    }
    @objc private func tappedDeleteButton(sender: UITapGestureRecognizer) {
        print("deletebuttton")
    }
    
    private func setUI() {
        contentView.addSubview(background)
        background.addSubViews([iconImageView, positivePercentLabel, dateLabel, contentsLabel, lineView, editButton, deleteButton])
        background.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(50)
        }
        positivePercentLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(iconImageView)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
            make.centerY.equalTo(iconImageView)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(positivePercentLabel.snp.bottom).offset(10)
            make.leading.equalTo(iconImageView)
            make.trailing.equalTo(dateLabel)
            make.height.equalTo(contentsLabel.font.pointSize * 3 + 10)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentsLabel)
            make.height.equalTo(1)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(5)
            make.leading.equalTo(lineView)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(100)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(editButton)
            make.trailing.equalTo(lineView)
            make.bottom.equalTo(editButton)
            make.width.equalTo(100)
        }
    }
}
