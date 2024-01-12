//
//  JadaIconLabelButtonView.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/09.
//

import UIKit
import SnapKit

final class JadaIconLabelButtonView: UIView {
    private let iconSize: Int
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    init(frame: CGRect = .zero, label: String, icon: UIImage?, iconSize: Int, font: UIFont = .jadaTitleFont) {
        if let icon = icon {
            iconImageView.image = icon.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = .jadaDarkGreen
        }
        self.iconSize = iconSize
        self.label.text = label
        self.label.font = font
        super.init(frame: frame)
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubViews([iconImageView, label])
        
        iconImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.height.equalTo(iconSize)
        }
        label.snp.makeConstraints { make in
            make.top.bottom.centerY.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(5)
        }
    }
}
