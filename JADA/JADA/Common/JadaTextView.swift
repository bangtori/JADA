//
//  JadaTextView.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/09.
//

import UIKit
import SnapKit

final class JadaTextView: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.jadaDarkGreen.cgColor
        borderLayer.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 2)
        layer.addSublayer(borderLayer)
        
        let bottomBorderLayer = CALayer()
        bottomBorderLayer.backgroundColor = UIColor.jadaDarkGreen.cgColor
        bottomBorderLayer.frame = CGRect(x: 0, y: bounds.size.height - 2, width: bounds.size.width, height: 2)
        layer.addSublayer(bottomBorderLayer)
    }
}
