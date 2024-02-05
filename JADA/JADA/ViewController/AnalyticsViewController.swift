//
//  AnalyticsViewController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/09.
//

import UIKit
import SnapKit
import FirebaseFirestore

final class AnalyticsViewController: UIViewController {
    private var diaries: [Diary] = []
    private let contentView: UIView = UIView()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaTitleFont
        label.textColor = .black
        return label
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaBodyFont
        label.textColor = .black
        return label
    }()
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.layer.cornerRadius = 10
        button.backgroundColor = .jadaDangerRed.withAlphaComponent(0.3)
        var attString = AttributedString("로그아웃")
        attString.font = .jadaCalloutFont
        attString.foregroundColor = .black
        button.tintColor = .clear
        button.configuration?.attributedTitle = attString
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        return button
    }()
    private let countingInfoContainer = UIView()
    private let totalDiaryCountView: MyCountingInfoView = MyCountingInfoView(description: "누적 일기 수")
    private let positiveDiaryCountView: MyCountingInfoView = MyCountingInfoView( description: "긍정 일기 수")
    private let monthlyAnalysticsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaTitleFont
        label.textColor = .black
        label.text = "이번달 감정 통계"
        return label
    }()
    private let colorDescriptionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 15
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    private let positiveColorDescription: ColorDescriptionView = ColorDescriptionView(emotion: .positive)
    private let neutralColorDescription: ColorDescriptionView = ColorDescriptionView(emotion: .neutral)
    private let negativeColorDescription: ColorDescriptionView = ColorDescriptionView(emotion: .negative)
    private var monthlyChart: PieChartView = PieChartView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configCountingData()
        configPieChart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation(title: "Analytics")
        view.backgroundColor = .white
        setUI()
        configData()
        configButtons()
    }
    
    private func configPieChart() {
        loadChartData { [weak self] data in
            guard let self = self else { return }
            monthlyChart.redraw(newData: data)
        }
    }
    
    private func loadChartData(completion: @escaping (([Emotion: Double]?) -> Void)) {
        var emotionCountData: [Emotion: Double] = [:]
        guard let userId = UserDefaultsService.shared.getData(key: .userId) as? String else {
            completion(nil)
            return }
        let dbRef = Firestore.firestore()
        
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
        let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!

        let startTimestamp = startOfMonth.timeIntervalSince1970
        let endTimestamp = endOfMonth.timeIntervalSince1970
        
        DispatchQueue.global().async {
            let query = dbRef.collection(Collections.diary.name)
                .whereField("writerId", isEqualTo: userId)
                .whereField("date", isGreaterThanOrEqualTo: startTimestamp)
                .whereField("date", isLessThan: endTimestamp)

            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error: 차트 데이터 가져오기 실패\n\(error)")
                    completion(nil)
                    return
                }
                
                if let documents = querySnapshot?.documents {
                    if documents.isEmpty {
                        print("document is Empty")
                        completion(nil)
                    } else {
                        var result: [Diary] = []
                        for document in documents {
                            if let temp = try? document.data(as: Diary.self) {
                                result.append(temp)
                            }
                        }
                        Emotion.allCases.forEach { emotion in
                            emotionCountData[emotion] = Double(result.filter { $0.emotion == emotion }.count) / Double(result.count)
                        }
                        completion(emotionCountData)
                    }
                }
            }
        }
    }
    
    private func configCountingData() {
        guard let userId = UserDefaultsService.shared.getData(key: .userId) as? String else { return }
        FirestoreService.shared.searchDocumentWithEqualField(collectionId: .diary, field: "writerId", compareWith: userId, dataType: Diary.self, isDateOrder: false) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                totalDiaryCountView.configCountingData(data.count)
                positiveDiaryCountView.configCountingData(data.filter{
                    $0.emotion == .positive
                }.count)
            case .failure(let error):
                print("Error: 일기 불러오기 실패\n\(error)")
            }
        }
    }
    private func configButtons() {
        logoutButton.addTarget(self, action: #selector(tappedLogoutButton), for: .touchUpInside)
    }
    
    @objc private func tappedLogoutButton(_ sender: UIButton) {
        UserDefaultsService.shared.removeAll()
        let viewController = SignInViewController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(viewController, animated: true)
    }
    
    private func configData() {
        guard let nickname = UserDefaultsService.shared.getData(key: .nickName) as? String else { return }
        nicknameLabel.text = "\(nickname)님"
        emailLabel.text = UserDefaultsService.shared.getData(key: .email) as? String
    }
    
    private func setUI() {
        view.addSubview(contentView)
        contentView.addSubViews([nicknameLabel, emailLabel, logoutButton, countingInfoContainer, monthlyAnalysticsTitleLabel, colorDescriptionStackView, monthlyChart])
        countingInfoContainer.addSubViews([totalDiaryCountView, positiveDiaryCountView])
        [positiveColorDescription, neutralColorDescription, negativeColorDescription].forEach {
            colorDescriptionStackView.addArrangedSubview($0)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()

        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        countingInfoContainer.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        totalDiaryCountView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        positiveDiaryCountView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(totalDiaryCountView.snp.trailing).offset(40)
        }
        
        monthlyAnalysticsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(countingInfoContainer.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        colorDescriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(monthlyAnalysticsTitleLabel.snp.bottom).offset(15)
            make.leading.equalTo(monthlyAnalysticsTitleLabel)
        }
        
        monthlyChart.snp.makeConstraints { make in
            make.top.equalTo(colorDescriptionStackView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(monthlyChart.snp.width)
            make.bottom.equalTo(contentView).offset(-10)
        }
    }
}


final class MyCountingInfoView: UIView {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaAnalyticsFont
        label.textColor = .jadaDarkGreen
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaNonBoldTitleFont
        label.textColor = .black
        return label
    }()
    
    init(description: String) {
        descriptionLabel.text = description
        super.init(frame: .zero)
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCountingData(_ count: Int) {
        countLabel.text = "\(count)"
    }
    
    private func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

final class ColorDescriptionView: UIView {
    private let colorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.font = .jadaCalloutFont
        label.textColor = .black
        return label
    }()
    
    init(emotion: Emotion) {
        switch emotion {
        case .positive:
            colorImageView.image = UIImage(named: "greenCircle")
            colorLabel.text = "긍정"
        case .neutral:
            colorImageView.image = UIImage(named: "blueCircle")
            colorLabel.text = "중립"
        case .negative:
            colorImageView.image = UIImage(named: "redCircle")
            colorLabel.text = "부정"
        }
        super.init(frame: .zero)
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI() {
        addSubViews([colorImageView, colorLabel])
        
        colorImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        colorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(colorImageView)
            make.leading.equalTo(colorImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
    }
}

final class PieChartView: UIView {
    private var data: [Emotion: Double]?
    
    init(data: [Emotion : Double]? = nil) {
        self.data = data
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let bgColor = UIColor.white
        bgColor.setFill()
        UIBezierPath(rect: rect).fill()
        
        let radius = rect.width / 2 * 0.6
        let cx = rect.midX
        let cy = rect.midY
        var startAngle: CGFloat = 0
        if let data = data {
            data.forEach({ key, value in
                key.chartColor.setFill()
                
                let endAngle = startAngle + .pi * 2 * value
                let arcPath = UIBezierPath()
                arcPath.move(to: CGPoint(x: cx, y: cy))
                arcPath.addArc(withCenter: CGPoint(x: cx, y: cy),
                               radius: radius,
                               startAngle: startAngle,
                               endAngle: endAngle,
                               clockwise: true)
                arcPath.close()
                arcPath.fill()
                startAngle = endAngle
            })
            
            bgColor.setStroke()
            startAngle = 0
            let x = cx + radius
            let y = cy
            data.forEach({ key, value in
                let endAngle = startAngle + .pi * 2 * value
                
                let angle = Double(startAngle)
                let x2 = cos(angle) * Double(x - cx) - sin(angle) * Double(y - cy) + Double(cx)
                let y2 = sin(angle) * Double(x - cx) + cos(angle) * Double(y - cy) + Double(cy)
                
                let linePath = UIBezierPath()
                linePath.lineWidth = 2
                linePath.move(to: CGPoint(x: cx, y: cy))
                linePath.addLine(to: CGPoint(x: x2, y: y2))
                linePath.stroke()
                
                startAngle = endAngle
            })
        } else {
            // data가 nil인 경우
            UIColor.jadaLightGray.setFill()
            let endAngle = startAngle + .pi * 2
            let arcPath = UIBezierPath()
            arcPath.move(to: CGPoint(x: cx, y: cy))
            arcPath.addArc(withCenter: CGPoint(x: cx, y: cy),
                           radius: radius,
                           startAngle: startAngle,
                           endAngle: endAngle,
                           clockwise: true)
            arcPath.close()
            arcPath.fill()
        }
    }
    
    func redraw( newData: [Emotion: Double]?) {
        data = newData
        setNeedsDisplay()
    }
}
