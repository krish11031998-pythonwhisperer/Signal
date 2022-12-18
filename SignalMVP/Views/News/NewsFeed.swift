//
//  NewsViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine

class NewsFeed: UIViewController {
	
	private lazy var tableView: UITableView = { .init(frame: .zero, style: .grouped) }()
    private var cancellable: Set<AnyCancellable> = .init()
//	private var observer: NSKeyValueObservation?
//	private var yOff: CGFloat = .zero
	
    private let viewModel: NewsViewModel = .init()
	
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
		setupObservers()
	}

	//MARK: - ProtectedMethods
	
	private func setupViews(){
		view.backgroundColor = .surfaceBackground
		view.addSubview(tableView)
		tableView.backgroundColor = .surfaceBackground
		tableView.separatorStyle = .none
		view.setFittingConstraints(childView: tableView, insets: .zero)
        
	}
	
	private func setupNavbar() {
        standardNavBar(leftBarButton: .init(customView: "News".heading2().generateLabel))
	}
	
	private func setupObservers() {
        viewModel.selectedNews
            .compactMap { $0 }
            .sink { [weak self] in
                guard let nav = self?.navigationController else { return }
                nav.pushViewController(NewsDetailView(news: $0), animated: true)
            }
            .store(in: &cancellable)
        
        viewModel.news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] section in
                self?.tableView.reloadData(.init(sections: [section]))
            }
            .store(in: &cancellable)
	}
}


//MARK: - AnyView

extension NewsFeed: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}
