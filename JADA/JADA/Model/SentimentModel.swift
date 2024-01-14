//
//  SentimentModel.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/14.
//

import Foundation

// MARK: - SentimentModel
struct SentimentModel: Codable {
    let document: Document
    let sentences: [Sentence]
}

// MARK: - Document
struct Document: Codable {
    let sentiment: String
    let confidence: Confidence
}

// MARK: - Confidence
struct Confidence: Codable {
    let neutral, positive, negative: Double
}

// MARK: - Sentence
struct Sentence: Codable {
    let content: String
    let offset, length: Int
    let sentiment: String
    let confidence: Confidence
    let highlights: [Highlight]
}

// MARK: - Highlight
struct Highlight: Codable {
    let offset, length: Int
}
