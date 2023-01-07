//
//  ProfileTickerSearch.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 31/12/2022.
//

import Foundation
import UIKit
import Combine

class ProfileSearchViewController: SearchViewController {
    
    private lazy var tableView: UITableView = { .standardTableView() }()
    private let selectedTicker: CurrentValueSubject<String?, Never>
    init(selectedTicker: CurrentValueSubject<String?, Never>) {
        self.selectedTicker = selectedTicker
        super.init(placeHolder: "Search Tickers", resultController: NewsSearchResultController.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        bind()
    }
    
    private func setupNavBar() {
        standardNavBar(title: "Find Tickers".heading5())
    }
    
    private func setupView() {
        view.backgroundColor = .surfaceBackground
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: .zero)
    }
    
    
    private func bind() {
        
        TickerService
            .shared
            .trending()
            .receive(on: RunLoop.main)
            .compactMap {
                $0.coins?.map { item in
                    let ticker = item.item
                    let model: RoundedCardCellModel = .init(model: .init(ticker)) {
                        self.selectedTicker.send(ticker.symbol)
                        self.dismiss(animated: true)
                    }
                    return model
                }
            }
            .sink {
                if let err = $0.err?.localizedDescription {
                    print("(ERROR) err: ", err)
                }
            } receiveValue: { [weak self] coins in
                guard let self else { return }
                self.tableView.reloadData(.init(sections: [.init(rows: coins.map { TableRow<RoundedCardCell>($0) }, title: "Trending Coins")]))
            }
            .store(in: &bag)

        
        search
            .sink { [weak self] in
                guard let self, let ticker = $0 else { return }
                self.selectedTicker.send(ticker)
                self.dismiss(animated: true)
            }
            .store(in: &bag)
    }
}
