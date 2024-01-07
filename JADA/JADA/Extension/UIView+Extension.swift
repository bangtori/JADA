//
//  UIView+Extension.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/08.
//

import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
