//
//  UIViewController+Extension.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/08.
//

import UIKit

extension UIViewController {
    /// 알림창 띄우기
    func showAlert(message: String, title: String = "알림", isCancelButton: Bool = false, yesButtonTitle: String = "확인", yesAction: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yes = UIAlertAction(title: yesButtonTitle, style: .default) { _ in
            yesAction?()
        }
        
        if isCancelButton {
            let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            alert.addAction(cancel)
        }
        alert.addAction(yes)
        
        present(alert, animated: true, completion: nil)
    }
    
    func configNavigation(title: String) {
        self.title = title
        self.navigationController?.navigationBar.tintColor = .jadaMainGreen
    }
}

