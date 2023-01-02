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
    private let user: CurrentValueSubject<UserModel?, Never> = .init(nil)
    private lazy var tableView: UITableView = { .standardTableView() }()

    private lazy var viewModel: HomeViewModel = { .init() }()
    
    private var bag: Set<AnyCancellable> = .init()
	
//MARK: - Overriden Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
        bind()
	}
	
//MARK: - ProtectedMethods
	
    private func setupNavbar() {
        setupTransparentNavBar(color: .surfaceBackground, scrollColor: .surfaceBackground)
        let customView = (UIImage.Catalogue.user.image.resized(size: .init(squared: 20)).withTintColor(.surfaceBackground) + "Profile".styled(font: .regular, color: .textColorInverse, size: 12)).generateLabel.blobify(backgroundColor: .surfaceBackgroundInverse, edgeInset: .init(vertical: 5, horizontal: 10), borderColor: .clear, borderWidth: 0, cornerRadius: 16)
        customView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProfile)))
        navigationItem.rightBarButtonItem = .init(customView: customView)
    }
    
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
                case .toTickerStory(let model, let frame):
                    let view = TickerStoryView(mention: model).withNavigationController()
                    self.presentView(style: .circlar(frame: frame), target: view, onDimissal: nil)
                case .viewMoreNews:
                    self.navigationController?.pushViewController(NewsFeed(isChildPage: true), animated: true)
                case .viewMoreTweet:
                    self.navigationController?.pushViewController(TweetFeedViewController(isChildPage: true), animated: true)
                case .viewMoreEvent:
                    self.navigationController?.pushViewController(EventsFeedViewController(isChildPage: true), animated: true)
                }
            }
            .store(in: &bag)
        
        output
            .user
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {
                if let err = $0.err?.localizedDescription {
                    print("(ERROR) err: ", err)
                }
            }, receiveValue: { [weak self] in
                guard let self else { return }
                self.user.send($0)
                self.setupNavbar()
            })
            .store(in: &bag)
    }
    
    @objc
    private func showProfile() {
        if let user = user.value {
            presentView(style: .sheet(size: .totalScreenSize),
                        target: ProfileViewController(user: user).withNavigationController(),
                        onDimissal: nil)
        }
    }
	
}
