//
//  TweetsFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit
import Combine

class TweetFeedViewController: UIViewController {
	
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
    private var bag: Set<AnyCancellable> = .init()
    
//MARK: - Overriden Methods
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupNavbar()
		viewModel.fetchTweets()
        setupObservers()
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

    private func loadMoreTweets(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - 200 - scrollView.frame.height && !viewModel.loading {
            self.viewModel.fetchNextPage()
        }
    }
}

extension TweetFeedViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
//		tableView.reloadData()
	}
}
