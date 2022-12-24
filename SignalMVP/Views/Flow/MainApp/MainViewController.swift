//
//  ViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import UIKit

class MainViewController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
        setupMainApp()
	}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserIsLoggedIn()
    }
    private func checkUserIsLoggedIn() {
        let userloggedIn = (UserDefaultStoreKey.loggedIn.value as? Bool) ?? false
        guard !userloggedIn  else { return }
        DispatchQueue.main.async {
            self.presentView(style: .sheet(),
                        addDimmingView: true,
                        target: OnboardingController().withNavigationController(),
                        onDimissal: nil)
        }
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

