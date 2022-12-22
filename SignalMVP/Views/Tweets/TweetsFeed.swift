//
//  TweetsFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit
import Combine

class TweetFeedViewController: SearchViewController {
	
//	private var observer: NSKeyValueObservation?
	private var yOff: CGFloat = .leastNormalMagnitude
	private var tableViewInitialContentOffset: CGFloat?
	private lazy var viewModel: TweetFeedViewModel = {
		let model = TweetFeedViewModel()
		model.view = self
		return model
	}()
	
	private lazy var tableView: UITableView = {
		let tableView: UITableView = .init(frame: .zero, style: .grouped)
		tableView.showsVerticalScrollIndicator = false
		return tableView
	}()
    
//MARK: - Overriden Methods
    init() {
        super.init(resultController: NewsSearchResultController.self)
    }
        
    required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupNavbar()
//		viewModel.fetchTweets()
        bind()
        setupObservers()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loading.send(true)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
//MARK: - Protected Methods

	private func setupViews() {
		view.addSubview(tableView)
		view.backgroundColor = .surfaceBackground
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		view.setFittingConstraints(childView: tableView, insets: .zero)
	}
	
    private func setupObservers() {
        tableView.publisher(for: \.contentOffset)
            .sink { [weak self] _ in
                guard let `self` = self else { return }
                self.setupScrollObserver(self.tableView)
            }
            .store(in: &bag)
        
        viewModel.$selectedTweet
            .compactMap { $0 }
            .sink { [weak self] in
                guard let `self` = self else { return }
                self.navigationController?.pushViewController(TweetDetailView(tweet: $0), animated: true)
            }
            .store(in: &bag)
    }
    
	private func setupScrollObserver(_ scrollView: UITableView) {
		guard scrollView.contentSize.height > .totalHeight,
			  scrollView.contentOffset.y >=  scrollView.contentSize.height - scrollView.frame.height else { return }
		self.viewModel.fetchNextPage()
	}
	
	private func setupNavbar() {
        standardNavBar(leftBarButton: .init(customView: "Tweets".heading2().generateLabel))
	}
    
    private func bind() {
        let output = viewModel.transform(input: .init(searchParam: searchText.eraseToAnyPublisher()))
        
        output.sections
            .receive(on: RunLoop.main)
            .sink {
                if let err = $0.err {
                    print("(ERROR) err: ", err)
                }
            } receiveValue: { [weak self] in
                self?.tableView.reloadData(.init(sections: [$0]))
            }
            .store(in: &bag)

    }
}

extension TweetFeedViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
//		tableView.reloadData()
	}
}
