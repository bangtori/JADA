//
//  Diary.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/25.
//

import Foundation

struct Diary: Codable {
    var id: String = UUID().uuidString
    var createdDate: Double = Date().timeIntervalSince1970
    let writerId: String
    let contents: String
    let emotion: Emotion
}
