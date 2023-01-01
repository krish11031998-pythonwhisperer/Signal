//
//  ViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import UIKit
import Combine

class MainViewController: UITabBarController {
	
    private let authPublisher: AuthPublisher = .init()
    private var bag: Set<AnyCancellable> = .init()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        setupMainApp()
        authPublisherListener()
	}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserIsLoggedIn()
    }
    private func checkUserIsLoggedIn() {
        let userloggedIn: Bool = UserDefaultStoreKey.loggedIn.value() ?? false
        guard !userloggedIn  else { return }
        DispatchQueue.main.async {
            self.presentView(style: .sheet(),
                        addDimmingView: true,
                        target: OnboardingController().withNavigationController(),
                        onDimissal: nil)
        }
    }

    private func authPublisherListener() {
        authPublisher
            .sink { [weak self] user in
                guard let self, let user = user else { return }
                UserDefaultStoreKey.loggedIn.setValue(true)
            }
            .store(in: &bag)
    }
    
    private func setupMainApp() {
        view.backgroundColor = .clear
        setViewControllers(tabBarViewController(), animated: true)
        let tabBar = { () -> MainTab in
            let tabBar = MainTab()
            tabBar.delegate = self
            return tabBar
        }()
        self.setValue(tabBar, forKey: "tabBar")
        tabBar.tintColor = .surfaceBackgroundInverse
    }
	
	private func tabBarViewController() -> [UINavigationController] {
        let homeNavView = HomeFeed().withNavigationController().tabBarItem(.home)
        let tweetNavView = TweetFeedViewController().withNavigationController().tabBarItem(.tweets)
        let newsNavView = NewsFeed().withNavigationController().tabBarItem(.news)
        let eventNavView = EventsFeedViewController().withNavigationController().tabBarItem(.events)
        let redditNavView = RedditFeedViewController().withNavigationController().tabBarItem(.init(name: "Reddit", iconName: .moon))
        let videoNavView = VideoViewController().withNavigationController().tabBarItem(.videos)
		return [homeNavView, videoNavView, newsNavView, eventNavView, tweetNavView]
	}

}

