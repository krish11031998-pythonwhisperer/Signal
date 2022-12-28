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
	
	private lazy var tableView: UITableView = { .init(frame: .zero, style: .grouped) }()
    private let viewModel: NewsViewModel = .init()
    
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
		bind()
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
    
    private func bind () {
        
        viewModel.selectedNews
            .compactMap { $0 }
            .sink { [weak self] in
                guard let nav = self?.navigationController else { return }
                nav.pushViewController(NewsDetailView(news: $0), animated: true)
            }
            .store(in: &bag)
        
        let searchParam = searchText.eraseToAnyPublisher().share().makeConnectable()
        
        let output = viewModel.transform(input: .init(searchParam: searchParam, nextPage: tableView.nextPage))
        
        output
            .tableSection
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print("(ERROR) err: ", $0.err?.localizedDescription)
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
