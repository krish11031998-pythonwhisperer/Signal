//
//  TopTrendingView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 03/01/2023.
//

import Foundation
import UIKit
import Combine

class TopTrendingViewController: UIViewController {
    
    private lazy var tableView: UITableView = { .standardTableView() }()
    private let viewModel: TopTrendingViewModel
    private var bag: Set<AnyCancellable> = .init()
    init(trendingTicker: [MentionTickerModel]) {
        self.viewModel = .init(tickers: trendingTicker)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupnNavBar()
        setupView()
        bind()
    }
    
    private func setupnNavBar() {
        standardNavBar(title: "Top Mentions".heading2())
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: .zero)
    }
    
    private func bind() {
        let output = viewModel.transform()
        
        output.section
            .map { TableViewDataSource(sections: $0) }
            .sink { [weak self] in
                self?.tableView.reloadData($0)
            }
            .store(in: &bag)
        
        output.navigation
            .sink { [weak self] in
                switch $0 {
                case .toTickerDetail(let mention):
                    self?.pushTo(target: TopMentionDetailView(mention: mention))
                }
            }
            .store(in: &bag)
    }
    
    
    
}
