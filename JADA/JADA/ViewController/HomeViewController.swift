//
//  HomeViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/09.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 목표"
        label.font = .jadaTitleFont
        label.textColor = .black
        return label
    }()
    private let goalEditButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .jadaMainGreen
        return button
    }()
    private let goalDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 감정을 챙기기 위한 목표를 적어보아요."
        label.font = .jadaCalloutFont
        label.textColor = .jadaGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let goalTextView: JadaTextView = {
        let textView = JadaTextView()
        textView.isEditable = false
        textView.font = .jadaTitleFont
        textView.textAlignment = .center
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavigation(title: "Home")
        setUI()
        configButtons()
    }
    
    private func configButtons() {
        goalEditButton.addTarget(self, action: #selector(tappedgoalEditButtonn), for: .touchUpInside)
    }
    
    @objc private func tappedgoalEditButtonn(_ sender: UIButton) {
        let viewController = GoalEditView()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func setUI() {
        view.addSubViews([goalLabel, goalEditButton, goalDescriptionLabel, goalTextView])
        
        goalLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.height.equalTo(goalLabel.font.pointSize)
        }
        goalEditButton.snp.makeConstraints { make in
            make.top.bottom.centerY.equalTo(goalLabel)
            make.leading.equalTo(goalLabel.snp.trailing).offset(5)
            make.width.equalTo(goalLabel.snp.height)
        }
        goalDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(goalLabel.snp.bottom).offset(5)
            make.leading.equalTo(goalLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
        goalTextView.snp.makeConstraints { make in
            make.top.equalTo(goalDescriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(goalDescriptionLabel)
            make.height.equalTo(80)
        }
    }
}

extension HomeViewController: GoalEidtDelegate {
    func saveGoal(goal: String) {
        goalTextView.text = goal
    }
}
