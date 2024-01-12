//
//  Date+Extensions.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/12.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd EEE"
        return dateFormatter.string(from: self)
    }
}
