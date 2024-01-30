//
//  CalendarCell.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/16.
//

import UIKit
import SnapKit
import FSCalendar

final class CalendarCell: FSCalendarCell {
    
    // 뒤에 표시될 이미지
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    @available(*, unavailable)
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
    }
    func configData(emotion: Emotion?) {
        if let emotion = emotion {
            iconImageView.image = UIImage(named: emotion.rawValue)
        } else {
            iconImageView.image = UIImage(named: "non")
        }
        
    }
    private func minSize() -> CGFloat {
        let width = contentView.bounds.width - 5
        let height = contentView.bounds.height - 5

        return (width > height) ? height : width
    }
    
    private func setUI() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.centerX.equalTo(contentView)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(titleLabel.font.pointSize)
        }
        
        contentView.insertSubview(iconImageView, at: 0)
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.leading.trailing.equalTo(contentView)
        }

    }
}
