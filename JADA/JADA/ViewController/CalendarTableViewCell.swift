//
//  CalendarTableViewCell.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/16.
//

import UIKit
import SnapKit

final class CalendarTableViewCell: UITableViewCell {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configData(diary: Diary) {
        iconImageView.image = UIImage(named: diary.emotion.rawValue)
        dateLabel.text = Date(timeIntervalSince1970: diary.date).toString()
        contentsLabel.text = diary.contents
    }
    
    private func setUI() {
        contentView.addSubViews([iconImageView, dateLabel, contentsLabel])
        
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().offset(15)
            make.size.equalTo(50)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(dateLabel.font.pointSize)
        }
        contentsLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(dateLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(dateLabel)
            make.bottom.equalTo(iconImageView)
        }
    }
}
