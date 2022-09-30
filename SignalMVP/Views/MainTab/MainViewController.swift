//
//  ViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import UIKit

extension UITabBarItem {
	
	convenience init(model: MainTabModel, tag: Int) {
		self.init(title: model.name, image: model.tabImage, tag: tag)
	}
	
}

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
		tabBar.tintColor = .purple
	}

	
	private func tabBarViewController() -> [UINavigationController] {
		let homeNavView = UINavigationController(rootViewController: HomeFeed())
		homeNavView.tabBarItem = .init(model: .home, tag: 0)
		let tweetNavView = UINavigationController(rootViewController: TweetFeedViewController(nibName: nil, bundle: nil))
		tweetNavView.tabBarItem = .init(model: .tweets, tag: 1)
		let newsNavView = UINavigationController(rootViewController: NewsFeed())
		newsNavView.tabBarItem = .init(model: .news, tag: 2)
		let eventNavView = UINavigationController(rootViewController: EventsFeedViewController())
		eventNavView.tabBarItem = .init(model: .events, tag: 3)
		let redditNavView = UINavigationController(rootViewController: RedditFeedViewController())
		redditNavView.tabBarItem = .init(title: "Reddit", image: nil, tag: 4)
		return [homeNavView, tweetNavView, newsNavView, eventNavView]
	}

}

