//
//  HomeViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/09.
//

import UIKit
import SnapKit
import FirebaseFirestore

final class HomeViewController: UIViewController {
    private var lastDocumentSnapshot: DocumentSnapshot?
    private let footerView = FooterView()
    private let refreshControl = UIRefreshControl()
    private var isRefresh = false
    
    private var diaryList: [Diary] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var uid: String
    
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
        let jdTextView = JadaTextView()
        let textview = jdTextView.textview
        textview.isEditable = false
        textview.font = .jadaTitleFont
        textview.textAlignment = .center
        return jdTextView
    }()
    private let tableView: UITableView = UITableView()
    
    init(userId: String) {
        uid = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavigation(title: "Home")
        setUI()
        configButtons()
        configTableView()
        configNavigationBarButton()
        configRefresh()
        
    }
    
    private func loadData() {
        let itemsPerPage: Int = 10
        let goal = UserDefaultsService.shared.getData(key: .goal) as? String
        goalTextView.textview.text = (goal == nil) ? "" : goal
        
        var query = Firestore.firestore().collection(Collections.diary.name)
            .whereField("writerId", isEqualTo: uid)
            .order(by: "date", descending: true)
            .order(by: "createdDate", descending: true)
            .limit(to: itemsPerPage)
        
        if let lastSnapshot = lastDocumentSnapshot {
            query = query.start(afterDocument: lastSnapshot)
        }
        
        DispatchQueue.global().async {
            query.getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                    return
                }
                guard let documents = snapshot?.documents else { return }
                
                if documents.isEmpty {
                    return
                }
                
                lastDocumentSnapshot = documents.last
                
                for document in documents {
                    if let data = try? document.data(as: Diary.self) {
                        diaryList.append(data)
                    }
                }
            }
        }
    }
    
    private func configNavigationBarButton() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(tappedAddButton))
        addButton.tintColor = .jadaMainGreen
        addButton.accessibilityLabel = "일기 작성"
        navigationItem.rightBarButtonItem = addButton
    }
    private func configTableView() {
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 80)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.sectionHeaderTopPadding = 0.0
    }
    
    private func configButtons() {
        goalEditButton.addTarget(self, action: #selector(tappedgoalEditButton), for: .touchUpInside)
    }
    
    private func configRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refreshControl.tintColor = .jadaMainGreen
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        isRefresh = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            diaryList = []
            lastDocumentSnapshot = nil
            loadData()
            refresh.endRefreshing()
            isRefresh = false
        }
    }
    
    @objc private func tappedAddButton(_ sender: UIBarButtonItem) {
        let viewController = AddViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    @objc private func tappedgoalEditButton(_ sender: UIButton) {
        let viewController = GoalEditView()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func setUI() {
        view.addSubViews([goalLabel, goalEditButton, goalDescriptionLabel, goalTextView, tableView])
        
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
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(goalTextView.snp.bottom)
            make.leading.trailing.equalTo(goalTextView)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension HomeViewController: GoalEidtDelegate {
    func saveGoal(goal: String) {
        goalTextView.textview.text = goal
        UserDefaultsService.shared.updateData(key: .goal, value: goal)
        FirestoreService.shared.updateDocument(collectionId: .users, documentId: uid, field: "goal", data: goal) { result in
            switch result {
            case .success(_):
                print("Goal 데이터 업데이트 성공")
            case .failure(let error):
                print("Error: Goal 데이터 업데이트 실패\n\(error)")
            }
        }
    }
}

// MARK: - 테이블 뷰 관련
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.identifier, for: indexPath) as? DiaryListCell else {
            return UITableViewCell()
        }
        cell.configData(diary: diaryList[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diary = diaryList[indexPath.section]
        let viewController = DiaryDetailViewController(diary: diary)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Cell Delegate Button Event
extension HomeViewController: DiaryTableViewCellDelegate {
    func editButtonTapped(cell: DiaryListCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let viewController = AddViewController(diary: diaryList[indexPath.section])
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func deleteButtonTapped(cell: DiaryListCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let diary = diaryList[indexPath.section]
            showAlert(message: "\(Date(timeIntervalSince1970: diary.createdDate).toString()) 일기를 삭제합니다.", title: "일기 삭제", isCancelButton: true, yesButtonTitle: "삭제") {
                FirestoreService.shared.deleteDocument(collectionId: .diary, documentId: diary.id) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        print("\(diaryList[indexPath.section].id) 삭제 성공")
                        UserDefaultsService.shared.deletePost(deletePostEmotion: diaryList[indexPath.section].emotion)
                        diaryList.remove(at: indexPath.section)
                    case .failure(let error):
                        print("Error: 데이터 삭제 실패\n\(error)")
                        showAlert(message: "해당 일기를 삭제하는데 실패하였습니다. 다시 시도해주세요. \n오류가 계속될 시 문의해주세요.", title: "삭제 실패")
                    }
                }
            }
        }
    }
}

// MARK: - 페이징
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffsetY = scrollView.contentOffset.y
        let tableViewContentSizeY = tableView.contentSize.height
        
        if contentOffsetY > tableViewContentSizeY - scrollView.frame.size.height && !isRefresh {
            
            tableView.tableFooterView = footerView
            
            loadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tableView.tableFooterView = nil
            }
        }
    }
}

final class FooterView: UIView {
    let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .jadaMainGreen
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        indicatorView.startAnimating()
    }
    
    private func makeConstraints() {
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

