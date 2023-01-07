//
//  NewsViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine

class NewsFeed: SearchViewController {
	
	private lazy var tableView: UITableView = { .standardTableView() }()
    private let viewModel: NewsViewModel = .init()
    private lazy var refreshControl: UIRefreshControl = { .init() }()
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
        startLoadingAnimation()
		setupNavbar()
		bind()
	}

	//MARK: - ProtectedMethods
	
	private func setupViews(){
        tableView.refreshControl = refreshControl
		view.backgroundColor = .surfaceBackground
		view.addSubview(tableView)
		tableView.backgroundColor = .surfaceBackground
		tableView.separatorStyle = .none
		view.setFittingConstraints(childView: tableView, insets: .zero)
        
	}
	
	private func setupNavbar() {
        if !isChildPage {
            standardNavBar(leftBarButton: .init(customView: "News".heading2().generateLabel))
        } else {
            standardNavBar(title: "News".heading2())
        }
	}
    
    private func bind () {
        
        viewModel.selectedNews
            .compactMap { $0 }
            .sink { [weak self] in
                guard let nav = self?.navigationController else { return }
                nav.pushViewController(NewsDetailView(news: $0), animated: true)
            }
            .store(in: &bag)
        
        let searchParam = search.makeConnectable()
        
        let refreshControl = refreshControl
            .publisher(for: .valueChanged)

            .withLatestFrom(searchParam)
            .map { _, search in search }
            .eraseToAnyPublisher()
        
        let output = viewModel.transform(input: .init(searchParam: searchParam,
                                                      refresh: refreshControl,
                                                      nextPage: tableView.nextPage))
        
        output
            .tableSection
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.endLoadingAnimation()
            })
            .sink(receiveCompletion: {
                if let err = $0.err?.localizedDescription {
                    print("(ERROR) err: ", err)
                }
            }, receiveValue: { [weak self] section in
                self?.tableView.reloadData(.init(sections: [section]))
            })
            .store(in: &bag)
        
        searchParam
            .sink {[weak self] in
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
