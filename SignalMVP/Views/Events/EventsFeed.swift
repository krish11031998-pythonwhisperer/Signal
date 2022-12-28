//
//  EventsFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine
struct EventCellModel: ActionProvider {
	let model: EventModel
	var action: Callback?
}

class EventsFeedViewController: SearchViewController {
	
	private var yOff: CGFloat = .zero
	
	private lazy var tableView: UITableView = {
		let table: UITableView = .init(frame: .zero, style: .grouped)
		table.backgroundColor = .clear
		table.separatorStyle = .none
		return table
	}()
	
    private var viewModel: EventFeedViewModel = .init()
//    private var bag: Set<AnyCancellable> = .init()
	//MARK: - Overriden Methods
	
    init() {
        super.init(resultController: NewsSearchResultController.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupNavBar()
		setupObservers()
	}
	
	//MARK: - Protected Methods

	private func setupView() {
		view.addSubview(tableView)
		tableView.backgroundColor = .surfaceBackground
		view.backgroundColor = .surfaceBackground
        view.setFittingConstraints(childView: tableView, insets: .init(top: 0, left: 0, bottom: .safeAreaInsets.bottom, right: 0))
	}
	
	private func setupNavBar() {
        standardNavBar(leftBarButton: .init(customView: "Events".heading2().generateLabel), color: .surfaceBackground)
	}
	
	private func scrollViewUpdate(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		if self.yOff == .zero {
			self.yOff = offset.y
		}
		guard offset.y != yOff, let navBar = navigationController?.navigationBar else { return }
		let off = (self.yOff...0).percent(offset.y).boundTo()
		let navbarHeight: CGFloat = navBar.frame.height + navBar.frame.minY
		UIView.animate(withDuration: 0.25) {
			navBar.transform = .init(translationX: 0, y: -CGFloat(off) * navbarHeight)
		}
	}
	
	private func setupObservers() {
        
        viewModel.selectedEvent
            .sink { [weak self] in
                self?.navigationController?.pushViewController(EventDetailView(eventModel: $0), animated: true)
            }
            .store(in: &bag)
        
        let searchParam = searchText.eraseToAnyPublisher().share().makeConnectable()
        
        let output = viewModel.transform(input: .init(searchParam: searchParam, nextPage: tableView.nextPage.share()))
        
        output.tableSection
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print("(ERROR) err: ", $0.err?.localizedDescription)
            }, receiveValue: { [weak self] section in
                self?.tableView.reloadData(.init(sections: [section]), animation: .fade)
            })
            .store(in: &bag)
        
        searchParam
            .removeDuplicates()
            .sink { [weak self] in
                guard let self else {return}
                
                guard let search = $0, !search.isEmpty else {
                    if let headerView = self.tableView.headerView {
                        self.tableView.contentSize.height -= headerView.compressedSize.height
                        self.tableView.headerView?.animate(.fadeOut()) {
                            self.tableView.headerView = nil
                        }
                    }
                    return
                }
                let headerView = self.accessoryDisplay(search: search)
                self.tableView.headerView = headerView
                self.tableView.headerView?.alpha = 0
                self.tableView.contentSize.height += headerView.compressedSize.height
                headerView.animate(.fadeIn(duration: 1), removeAfterCompletion: false)
            }
            .store(in: &bag)
        
        searchParam.connect().store(in: &bag)
	}
	
	@objc
	private func showEventDetail() {
		navigationController?.pushViewController(EventDetailView(), animated: true)
	}
}

//MARK: - AnyTableView

extension EventsFeedViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}
