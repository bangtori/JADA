//
//  JadaTextView.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/09.
//

import UIKit
import SnapKit

final class JadaTextView: UIView {
    let textview: UITextView = UITextView()
    let topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .jadaDarkGreen
        return view
    }()
    let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .jadaDarkGreen
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubViews([topBorder, textview, bottomBorder])
        
        topBorder.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        textview.snp.makeConstraints { make in
            make.top.equalTo(topBorder.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        bottomBorder.snp.makeConstraints { make in
            make.top.equalTo(textview.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
    }
}
