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
	var loading: Bool = false
	var view: AnyTableView?
	
	public func fetchTweets() {
		guard !loading else { return }
		loading = true
		StubTweetService
			.shared
			.fetchTweets { [weak self] result in
				switch result {
				case .success(let searchResult):
					self?.decodeToTweetCellModel(.init(data: searchResult.data?.limitTo(to: 20), includes: searchResult.includes))
				case .failure(let err):
					print("(DEBUG) err : ", err.localizedDescription)
				}
			}
	}
	
	
	public func fetchNextPage() {
		print("(DEBUG) fetching next page!")
		guard !loading else { return }
		loading = true
		StubTweetService
			.shared
			.fetchTweets { [weak self] result in
				switch result {
				case .success(let searchResult):
					let presentCount = self?.tweets?.count ?? 0
					if let data = searchResult.data?.limitTo(offset: presentCount, to: presentCount + 20, replaceVal: []), !data.isEmpty {
						self?.decodeToTweetCellModel(.init(data: data, includes: searchResult.includes))
					}
				case .failure(let err):
					print("(DEBUG) err : ",err.localizedDescription)
				}
			}
	}
	
	private func decodeToTweetCellModel(_ data: TweetSearchResult) {
		guard let tweets = data.data,
			let allMedia = data.includes?.media,
			let allUsers = data.includes?.users
		else { return }
		
		let fitleredTweet = tweets.compactMap { tweet in
			let mediaKeys = tweet.attachments?.mediaKeys ?? []
			
			var model:TweetCellModel = .init(model: tweet,
						 media: mediaKeys.compactMap { key in allMedia.first { $0.mediaKey == key } }.emptyOrNil,
						 user: allUsers.first { $0.id == tweet.authorId })
			
			model.action = {
				TweetStorage.selectedTweet = model
			}
			
			return model
		}
	
		if self.tweets == nil {
			self.tweets = fitleredTweet
		} else {
			print("(DEBUG) Adding newTweets")
			self.tweets?.append(contentsOf: fitleredTweet)
		}
		
		loading.toggle()
		
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
