//
//  EventDetailView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 26/09/2022.
//

import Foundation
import UIKit
import Combine

class EventDetailView: UIViewController {


//MARK: - Properties
	private lazy var tableView: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		table.separatorStyle = .none
		return table
	}()
    private var viewModel: EventDetailViewModel
    private var bag: Set<AnyCancellable> = .init()
    
    init(eventModel: EventModel? = nil) {
        self.viewModel = .init(eventModel: eventModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Overriden Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
        bind()
        loadNewsForEvent()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTransparentNavBar(color: .surfaceBackground, scrollColor: .surfaceBackground)
        startLoadingAnimation()
    }
	
//MARK: - Protected Methods
	
    private func loadNewsForEvent() {
        if viewModel.needToLoadNews {
            viewModel.loadNewsForEvent()
        }
    }
    
	private func setupView() {
		view.addSubview(tableView)
		tableView.backgroundColor = .surfaceBackground
		view.backgroundColor = .surfaceBackground
		view.setFittingConstraints(childView: tableView, insets: .zero)
        standardNavBar(color: .clear, scrollColor: .clear)
	}
	
    private func bind() {
        let output = viewModel.transform()
        
        output
            .section
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.endLoadingAnimation()
            })
            .sink { [weak self] sections in
                self?.tableView.reloadData(.init(sections: sections))
            }
            .store(in: &bag)
        
        output
            .selectedNews
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self, let news = $0 else { return }
                self.navigationController?.pushViewController(NewsDetailView(news: news), animated: true)
            }
            .store(in: &bag)
    }
	
}
