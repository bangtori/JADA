//
//  Bundle+Extension.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/08.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "APIKeys", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let key = resource["API_KEY"] as? String else {
            fatalError("KEY를 찾을수없음")
        }
        return key
    }
}

