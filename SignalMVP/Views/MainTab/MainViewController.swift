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
		view.backgroundColor = .clear
		// Do any additional setup after loading the view.
		setViewControllers(tabBarViewController(), animated: true)
		let tabBar = { () -> MainTab in
			let tabBar = MainTab()
			tabBar.delegate = self
			return tabBar
		}()
		self.setValue(tabBar, forKey: "tabBar")
		selectedIndex = 0
	}

	
	private func tabBarViewController() -> [UINavigationController] {
		let tweetNavView = UINavigationController(rootViewController: TweetFeedViewController())
		tweetNavView.tabBarItem = .init(title: "Tweets", image: .init(systemName: "message"), tag: 1)
		let newsNavView = UINavigationController(rootViewController: NewsFeed())
		newsNavView.tabBarItem = .init(title: "News", image: .init(systemName: "newspaper"), tag: 2)
		let eventNavView = UINavigationController(rootViewController: EventsFeedViewController())
		eventNavView.tabBarItem = .init(title: "Events", image: .init(systemName: "wake"), tag: 3)
		let redditNavView = UINavigationController(rootViewController: RedditFeedViewController())
		redditNavView.tabBarItem = .init(title: "Reddit", image: nil, tag: 4)
		return [tweetNavView, newsNavView, eventNavView, redditNavView]
	}

}

