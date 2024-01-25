//
//  User.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/16.
//

import Foundation

struct User: Codable {
    var id: String = UUID().uuidString
    let email: String
    let password: String
    let nickname: String
    let postCount: Int
    let positiveCount: Int
    let goal: String
}
