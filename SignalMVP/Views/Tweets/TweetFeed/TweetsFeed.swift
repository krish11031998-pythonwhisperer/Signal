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
    private let refreshControl: UIRefreshControl = { .init() }()
	private lazy var tableView: UITableView = {
		let tableView: UITableView = .init(frame: .zero, style: .grouped)
		tableView.showsVerticalScrollIndicator = false
		return tableView
	}()
    private let isChildPage: Bool
    
//MARK: - Overriden Methods
    init(isChildPage: Bool = false) {
        self.isChildPage = isChildPage
        super.init(resultController: NewsSearchResultController.self)
    }
        
    required init?(coder: NSCoder) {
        self.isChildPage = false
		super.init(coder: coder)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupNavbar()
        bind()
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
        tableView.refreshControl = refreshControl
		view.addSubview(tableView)
		view.backgroundColor = .surfaceBackground
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		view.setFittingConstraints(childView: tableView, insets: .zero)
	}

	private func setupNavbar() {
        if !isChildPage {
            standardNavBar(leftBarButton: .init(customView: "Tweets".heading2().generateLabel))
        } else {
            standardNavBar(title: "Tweets".heading2())
        }
	}
    
    private func bind() {
        
        let contentOffset = tableView.publisher(for: \.contentOffset)
            .compactMap { [weak self] in
                guard let self,
                      self.tableView.contentSize.height > .totalHeight
                else { return false }
                return  $0.y >=  self.tableView.contentSize.height - self.tableView.frame.height
            }
            .eraseToAnyPublisher()
        
        let searchParam = searchText.eraseToAnyPublisher().share().makeConnectable()
        
        let refreshControl = refreshControl
            .publisher(for: .valueChanged)

            .withLatestFrom(searchParam)
            .map { _, search in search }
            .eraseToAnyPublisher()
        
        let output = viewModel.transform(input: .init(refresh: refreshControl,
                                                      searchParam: searchParam,
                                                      loadNextPage: contentOffset))
        
        output.sections
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .sink {
                if let err = $0.err {
                    print("(ERROR) err: ", err)
                }
            } receiveValue: { [weak self] in
                self?.tableView.reloadRows(.init(sections: [$0]), section: 0)
//                self?.tableView.reloadData(.init(sections: [$0]))
            }
            .store(in: &bag)
        
        viewModel.$selectedTweet
            .compactMap { $0 }
            .sink { [weak self] in
                guard let `self` = self else { return }
                self.navigationController?.pushViewController(TweetDetailView(tweet: $0), animated: true)
            }
            .store(in: &bag)
        
        searchParam
            .sink { [weak self] in
                guard let self else {return}
                guard let search = $0, !search.isEmpty else {
                    self.tableView.animateHeaderView = nil
                    return
                }
                let headerView = self.accessoryDisplay(search: search)
                self.tableView.animateHeaderView = headerView
            }
            .store(in: &bag)
        
        searchParam.connect().store(in: &bag)
    }
}

extension TweetFeedViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}
