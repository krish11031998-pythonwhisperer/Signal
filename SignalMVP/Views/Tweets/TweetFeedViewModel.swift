//
//  TweetFeedViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation


struct TweetCellModel: ActionProvider {
	let model: TweetModel?
	let media: [TweetMedia]?
	let user: TweetUser?
	var action: Callback?
}

protocol AnyTableView {
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource)
}

class TweetFeedViewModel {

	var tweets: [TweetCellModel]?
	
	var view: AnyTableView?
	
	public func fetchTweets() {
		StubTweetService.shared
			.fetchTweets { [weak self] result in
				switch result {
				case .success(let searchResult):
					self?.decodeToTweetCellModel(searchResult)
				case .failure(let err):
					print("(DEBUG) err : ", err.localizedDescription)
				}
			}
	}
	
	
	private func decodeToTweetCellModel(_ data: TweetSearchResult) {
		let tweets = data.data
		let allMedia = data.includes?.media
		let allUsers = data.includes?.users
		
		self.tweets = tweets?.compactMap { tweet in
			let mediaKeys = tweet.attachments?.mediaKeys ?? []
			
			var model:TweetCellModel = .init(model: tweet,
						 media: mediaKeys.compactMap { key in allMedia?.first { $0.mediaKey == key } }.emptyOrNil,
						 user: allUsers?.first { $0.id == tweet.authorId })
			
			model.action = {
				TweetStorage.selectedTweet = model
				NotificationCenter.default.post(name: .showTweet, object: nil)
			}
			
			return model
		} ?? []
	
		DispatchQueue.main.async {
			self.view?.reloadTableWithDataSource(self.buildDataSource())
		}
		
	}

	
	private func buildDataSource() -> TableViewDataSource {
		.init(sections: [tweetSection].compactMap { $0 })
	}
	
	private var tweetSection: TableSection? {
		guard let validTweets = tweets else { return nil }
		let rows = validTweets.compactMap { TableRow<TweetCell>($0) }
		return .init(rows: rows)
	}
}
