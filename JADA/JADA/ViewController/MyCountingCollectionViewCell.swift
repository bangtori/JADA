//
//  MyCountingCollectionViewCell.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/30.
//

import UIKit
import SnapKit

final class MyCountingCollectionViewCell: UICollectionViewCell {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaAnalyticsFont
        label.textColor = .jadaDarkGreen
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaNonBoldTitleFont
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configData() {
        countLabel.text = "134"
        descriptionLabel.text = "누적 일기 수"
    }
    private func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

