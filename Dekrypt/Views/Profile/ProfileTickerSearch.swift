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
    
    init() {
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
        search
            .sink {
                print("Selected Ticker:", $0)
            }
            .store(in: &bag)
    }
}
