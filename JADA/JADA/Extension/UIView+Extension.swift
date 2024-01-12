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
    
    /// 배경 탭하면 키보드 내리기
    func tappedDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
}
