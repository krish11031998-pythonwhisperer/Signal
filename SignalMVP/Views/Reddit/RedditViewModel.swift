//
//  RedditViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation

class RedditViewModel {
	
	private var posts: [RedditPostModel]?
	public var view: AnyTableView?
	
	public func fetchRedditPosts() {
		StubRedditService.shared.fetchRedditPosts { [weak self] result in
			switch result {
			case .success(let posts):
				self?.posts = posts
				guard let dataSource = self?.buildDataSource() else { return }
				DispatchQueue.main.async {
					self?.view?.reloadTableWithDataSource(dataSource)
				}
			case .failure(let err):
				print("(DEBUG) err : ",err.localizedDescription)
			}
		}
	}
	
	
	private var redditSection: TableSection? {
		guard let validPosts = posts else { return nil }
		return .init(rows: validPosts.compactMap{ TableRow<RedditPostCard>($0) })
	}
	
	private func buildDataSource() -> TableViewDataSource {
		.init(sections: [redditSection].compactMap { $0 })
	}
	
	
	
}
