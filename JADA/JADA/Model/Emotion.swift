//
//  Emotion.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/15.
//

import Foundation

enum Emotion: String {
    case positive
    case neutral
    case negative
    
    var resultDescription: String {
        switch self {
        case .positive:
            return "좋은 결과에요.\n내일도 이 감정을 이어가봐요."
        case .neutral:
            return "무난한 하루네요.\n내일은 조금 더 즐거운 하루가 될거에요."
        case .negative:
            return "오늘 하루 수고했어요.\n오늘 일은 신경쓰지말고 내일도 화이팅!"
        }
    }
    
}
