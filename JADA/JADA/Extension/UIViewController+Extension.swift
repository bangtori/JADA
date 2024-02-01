//
//  UIViewController+Extension.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/08.
//

import UIKit

extension UIViewController {
    /// 알림창 띄우기
    func showAlert(message: String, title: String = "알림", isCancelButton: Bool = false, yesButtonTitle: String = "확인", yesAction: (() -> Void)? = nil) {
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
    
    /// 네비게이션 타이틀 기본 설정
    func configNavigation(title: String) {
        self.title = title
        self.navigationController?.navigationBar.tintColor = .jadaMainGreen
    }
    
    /// 네비게이션 뒤로가기 버튼 숨기기
    /// -> 사용방법: a에서 b로 이동한다면 a에서 선언
    func hideNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    /// 토스트 메시지 출력
    func showToast(message : String, font: UIFont = .jadaCalloutFont) {
        DispatchQueue.main.async {
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.jadaGray.withAlphaComponent(0.5)
            toastLabel.textColor = UIColor.white
            toastLabel.font = font
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 15;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
}

