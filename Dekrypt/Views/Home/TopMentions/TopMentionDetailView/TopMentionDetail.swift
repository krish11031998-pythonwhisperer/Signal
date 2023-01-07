//
//  TopMentionDetail.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 02/11/2022.
//

import Foundation
import UIKit
import Combine
extension UITableView {
    
    static func standardTableView() -> UITableView {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .surfaceBackground
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        return table
    }
    
}

class TopMentionDetailView: UIViewController {

    private lazy var headerView: UIImageView = { .standardImageView(frame: CGSize(squared: 48).frame, circleFrame: true)
    }()
    private lazy var headerLabel = { UILabel() }()
    private lazy var symbolLabel: UILabel = { .init() }()
    private lazy var tableView: UITableView = { .standardTableView() }()
    private lazy var viewModel: TopMentionDetailViewModel = { .init(mention: mention) }()
    private var bag: Set<AnyCancellable> = .init()
    private lazy var chart: RatingChart = { .init() }()
    private let mention: MentionTickerModel
    
    init(mention: MentionTickerModel) {
        self.mention = mention
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTransparentNavBar()
        standardNavBar()
        setupView()
        tableView.reloadData(.init(sections: [viewModel.sentimentSplitView, .init(rows: [], title: "Media")].compactMap { $0 }))
        bind()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: .zero)
        addHeaderView()
    }
    
    private func addHeaderView() {
        let duallabel = UIStackView.VStack(subViews: [headerLabel, symbolLabel], spacing: 8, alignment: .leading)
        let infoStack: UIView = .HStack(subViews:[headerView, duallabel, .spacer()], spacing: 10, alignment: .center).embedInView(insets: .init(vertical: 10, horizontal: 15))
        mention.name.heading3().render(target: headerLabel)
        mention.ticker.body1Regular(color: .gray).render(target: symbolLabel)
        
        chart.setFrame(width: .totalWidth - 20, height: 200)
        
        UIImage.loadImage(url: (mention.ticker).logoURL, at: headerView, path: \.image).store(in: &bag)
        
        let headerView: UIView = .VStack(subViews: [infoStack, chart.embedInView(insets: .init(by: 10))], spacing: 20)
        headerView.setFrame(width: .totalWidth, height: headerView.compressedSize.height)
        tableView.headerView = headerView
    }
    
    private func bind() {
        let output = viewModel.transform()
        
        output.sections
            .receive(on: DispatchQueue.main  )
            .sink {
                print("(ERROR) err: ", $0.err?.localizedDescription)
            } receiveValue: { [weak self] in
                self?.tableView.replaceRows(rows: $0, section: 1)
            }
            .store(in: &bag)
        
        output
            .sentiment
            .receive(on: RunLoop.main)
            .sink {
                print("(ERROR) err: ", $0.err?.localizedDescription)
            } receiveValue: { [weak self] model in
                self?.chart.configureChart(model: model)
            }
            .store(in: &bag)
        
        output
            .navigation
            .sink { [weak self] nav in
                guard let self else { return }
                switch nav {
                case .event(let model):
                    self.pushTo(target: EventDetailView(eventModel: model))
                case .news(let model):
                    self.pushTo(target: NewsDetailView(news: model))
                case .tweet(let model):
                    self.pushTo(target: TweetDetailView(tweet: model))
                }
            }
            .store(in: &bag)
    }
    
}
