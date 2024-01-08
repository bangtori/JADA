//
//  JadaFilledButton.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/08.
//

import UIKit

final class JadaFilledButton: UIButton {
    
    init(title: String, cornerRadius: Double = 10.0, background: UIColor = .jadaMainGreen, textColor: UIColor = .white, font: UIFont = .jadaTitleFont) {
        super.init(frame: .zero)
        self.configuration = .none
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = background
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(textColor, for: .normal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
