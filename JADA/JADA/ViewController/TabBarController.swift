//
//  TabBarController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/09.
//

import UIKit
import SnapKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBar()
        configTabBarDesign()
    }
    
    private func configTabBar() {
        guard let userId = UserDefaultsService.shared.getData(key: .userId) as? String else {
            print("Error: UserDefaults UserId 가져오기 실패")
            showAlert(message: "유저정보를 가져오는데 실패했습니다. 다시 로그인해주세요.", title: "유저 정보 가져오기 실패") {
                UserDefaultsService.shared.removeAll()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(SignInViewController(), animated: true)
            }
            return
        }
        let homeViewController = UINavigationController(rootViewController: HomeViewController(userId: userId))
        let calendarViewController = UINavigationController(rootViewController: CalendarTableListController())
        let analyticsViewController = UINavigationController(rootViewController: AnalyticsViewController())
        
        homeViewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        calendarViewController.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(systemName: "calendar"), tag: 1)
        analyticsViewController.tabBarItem = UITabBarItem(title: "통계", image: UIImage(systemName: "chart.pie"), tag: 2)
        
        
        homeViewController.navigationBar.prefersLargeTitles = false
        calendarViewController.navigationBar.prefersLargeTitles = false
        analyticsViewController.navigationBar.prefersLargeTitles = false
        
        self.viewControllers = [homeViewController, calendarViewController, analyticsViewController]
        delegate = self
    }
    
    private func configTabBarDesign() {
        tabBar.tintColor = .jadaMainGreen
        tabBar.backgroundColor = .white
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator(viewControllers: tabBarController.viewControllers)
    }
}
