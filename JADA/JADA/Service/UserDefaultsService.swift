//
//  UserDefaultsService.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/24.
//

import Foundation

final class UserDefaultsService {
    enum Key: String, CaseIterable {
        case userId, email, password, nickName
        case goal
        case postCount, positiveCount
    }
    static let shared: UserDefaultsService = UserDefaultsService()
    
    func saveUserData(user: User) {
        UserDefaults.standard.setValue(user.id, forKey: Key.userId.rawValue)
        UserDefaults.standard.setValue(user.nickname, forKey: Key.nickName.rawValue)
        UserDefaults.standard.setValue(user.email, forKey: Key.email.rawValue)
        UserDefaults.standard.setValue(user.password, forKey: Key.password.rawValue)
        UserDefaults.standard.setValue(user.postCount, forKey: Key.postCount.rawValue)
        UserDefaults.standard.setValue(user.positiveCount, forKey: Key.positiveCount.rawValue)
        UserDefaults.standard.setValue(user.goal, forKey: Key.goal.rawValue)
    }
    
    func getData(key: Key) -> Any? {
        switch key {
        case .userId, .email, .password, .nickName, .goal:
            return UserDefaults.standard.string(forKey: key.rawValue)
        case .postCount, .positiveCount:
            return UserDefaults.standard.integer(forKey: key.rawValue)
        }
    }
    
    func updatePost(postResult: Emotion) {
        guard let currentPostCount = getData(key: .postCount) as? Int else { return }
        guard let currentPositiveCount = getData(key: .positiveCount) as? Int else { return }
        updateData(key: .postCount, value: currentPostCount + 1)
        if postResult == .positive {
            updateData(key: .positiveCount, value: currentPositiveCount + 1)
        }
    }
    
    func updateData(key: Key, value: Any) {
        switch key {
        case .userId, .email:
            break
        case .goal:
            UserDefaults.standard.setValue(value, forKey: Key.goal.rawValue)
        case .password:
            UserDefaults.standard.setValue(value, forKey: Key.password.rawValue)
        case .nickName:
            UserDefaults.standard.setValue(value, forKey: Key.nickName.rawValue)
        case .postCount:
            UserDefaults.standard.setValue(value, forKey: Key.postCount.rawValue)
        case .positiveCount:
            UserDefaults.standard.setValue(value, forKey: Key.positiveCount.rawValue)
        }
    }
    
    func removeAll() {
        Key.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
    
    func isLogin() -> Bool {
        UserDefaults.standard.string(forKey: Key.userId.rawValue) == nil ? false : true
    }
}
