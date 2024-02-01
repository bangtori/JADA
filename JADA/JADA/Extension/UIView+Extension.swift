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
    
    /// UIView 이미지로 변경
    func transfromToImage() -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
            defer {
                UIGraphicsEndImageContext()
            }
            if let context = UIGraphicsGetCurrentContext() {
                layer.render(in: context)
                return UIGraphicsGetImageFromCurrentImageContext()
            }
            return nil
        }
}
