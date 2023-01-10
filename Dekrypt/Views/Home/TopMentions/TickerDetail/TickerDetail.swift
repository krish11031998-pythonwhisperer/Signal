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

class TickerDetailView: UIViewController {

    private lazy var headerView: UIImageView = { .standardImageView(frame: CGSize(squared: 48).frame, circleFrame: true)
    }()
    private lazy var tableView: UITableView = { .standardTableView() }()
    private lazy var viewModel: TickerDetailViewModel = { .init(mention: mention) }()
    private var bag: Set<AnyCancellable> = .init()

//    private lazy var sentimentInfo: DualLabel = { .init(spacing: 8, alignment: .center) }()
//    private lazy var chart: RadialChart = {
//        let chart: RadialChart = .init()
//        chart.addSubview(sentimentInfo)
//        chart.setFittingConstraints(childView: sentimentInfo, bottom: 10, centerX: 0)
//        return chart
//    }()
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
        bind()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: .zero)
        addHeaderView()
    }
    
    private func addHeaderView() {
        var appearance = RoundedCardAppearance.plain
        appearance.insets = .init(by: 10)
        let headerView = RoundedCardView(appearance: appearance)
        let imageView : RoundedCardViewSideView = .image(url: mention.ticker.logoURL, size: CGSize(squared: 48), cornerRadius: 24)
        let cancellables = headerView.configureView(with: .init(title:  mention.name.heading3(),
                                                                subTitle: mention.ticker.body1Regular(color: .gray),
                                                                leadingView: imageView))
        headerView.setFrame(width: .totalWidth, height: headerView.compressedSize.height)
        cancellables?.forEach { bag.insert($0) }

        tableView.headerView = headerView
    }
    
    private func bind() {
        let output = viewModel.transform()
        
        viewModel.loading
            .dropFirst(1)
            .sinkReceive { [weak self] loading in
                self?.mediaSectionLoad(loading: loading)
            }
            .store(in: &bag)
        
        output
            .section
            .sinkReceive { [weak self] sections in
                guard let self else { return }
                self.tableView.reloadData(.init(sections: sections))
            }
            .store(in: &bag)
        
        output.mediaSection
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewModel.loading.send(false) })
            .sinkReceive { [weak self] in
                guard let self else { return }
                self.tableView.replaceRows(rows: $0, section: 2)
            }
            .store(in: &bag)
        
        output
            .navigation
            .sinkReceive { [weak self] nav in
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
    
    private func mediaSectionLoad(loading: Bool) {
        if loading {
            self.tableView.addSubview(LoadingIndicator.indicator)
            let frame = self.tableView.cellForRow(at: .init(row: 0, section: 2))?.frame ?? .zero
            self.tableView.hideTableSection(section: 2)
            LoadingIndicator.indicator.start(origin: .init(x: frame.midX, y: frame.minY + 16))
            self.tableView.isScrollEnabled = false
        } else {
            LoadingIndicator.indicator.stop()
            self.tableView.showTableSection(section: 2)
            self.tableView.isScrollEnabled = true
        }

    }
    
}
//MARK: - Constants
extension TickerDetailView {
    enum Constants {
        static let monthly = "Month Sentiment"
    }
}
