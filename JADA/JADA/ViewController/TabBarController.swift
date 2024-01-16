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
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        let calendarViewController = UINavigationController(rootViewController: CalendarTableListController())
        let analyticsViewController = UINavigationController(rootViewController: AnalyticsViewController())
        
        homeViewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        calendarViewController.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(systemName: "calendar"), tag: 1)
        analyticsViewController.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "chart.pie"), tag: 2)
        
        
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
