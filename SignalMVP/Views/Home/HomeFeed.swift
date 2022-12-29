//
//  HomeFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit
import Combine

class HomeFeed: UIViewController {
	
//MARK: - Properties
	
	private lazy var tableView: UITableView = {
		let table: UITableView = .init(frame: .zero, style: .grouped)
		table.separatorStyle = .none
		return table
	}()

	private lazy var viewModel: HomeViewModel = {
		let model = HomeViewModel()
        model.viewTransitioner = self
		return model
	}()
    
    private var bag: Set<AnyCancellable> = .init()
	
//MARK: - Overriden Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupTransparentNavBar()
        bind()
	}
	
//MARK: - ProtectedMethods
	
	private func setupViews() {
		view.addSubview(tableView)
		view.setFittingConstraints(childView: tableView, insets: .zero)
		view.backgroundColor = .surfaceBackground
		tableView.backgroundColor = .clear
	}
    
    private func bind() {
        let output = viewModel.transform()
        
        output.sections
            .map { TableViewDataSource(sections: $0) }
            .receive(on: DispatchQueue.main)
            .sink {
                print("(ERROR) err: ", $0.err?.localizedDescription)
            } receiveValue: { [weak self] in
                guard let self else { return }
                
                self.tableView.reloadData($0)
            }
            .store(in: &bag)

        output.navigation
            .sink { [weak self] in
                guard let self else { return }
                switch $0 {
                case .toEvent(let event):
                    self.navigationController?.pushViewController(EventDetailView(eventModel: event), animated: true)
                case .toNews(let news):
                    self.navigationController?.pushViewController(NewsDetailView(news: news), animated: true)
                case .toTweet(let tweet):
                    self.navigationController?.pushViewController(TweetDetailView(tweet: tweet), animated: true)
                case .toMention(_):
                    break
                case .viewMoreNews:
                    self.navigationController?.pushViewController(NewsFeed(isChildPage: true), animated: true)
                case .viewMoreTweet:
                    self.navigationController?.pushViewController(TweetFeedViewController(isChildPage: true), animated: true)
                case .viewMoreEvent:
                    self.navigationController?.pushViewController(EventsFeedViewController(isChildPage: true), animated: true)
                    print("(DEBUG) Clicked on :", $0)
                }
            }
            .store(in: &bag)
        
    }
	
}


//MARK: - Present Delegate

extension HomeFeed: PresentDelegate {
    
    func presentView(origin: CGRect) {
        guard let mention =  viewModel.selectedMention.value else { return }
        let view = TickerStoryView(mention: mention).withNavigationController()
        let presenter = PresentationController(style: .circlar(frame: origin),presentedViewController: view, presentingViewController: self, onDismiss: nil)
        view.transitioningDelegate = presenter
        view.modalPresentationStyle = .custom
        present(view, animated: true)
    }
    
}
