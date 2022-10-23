//
//  TweetFeedViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation


struct TweetCellModel: ActionProvider {
	let model: TweetModel?
	var action: Callback?
}

extension TweetCellModel {
	var media: [TweetMedia]? { model?.media }
	var user: TweetUser? { model?.user }
}

protocol AnyTableView {
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource)
}

class TweetFeedViewModel {

	var tweets: [TweetCellModel]?
	var loading: Bool = false
	var view: AnyTableView?
	
	public func fetchTweets(entity: String? = nil, before: String? = nil, after: String? = nil, limit: Int = 20) {
		guard !loading else { return }
		loading = true
		TweetService
			.shared
			.fetchTweets(entity: entity, before: before, after: after) { [weak self] result in
                if let result = result.data {
                    self?.decodeToTweetCellModel(result)
                } else {
                    StubTweetService.shared.fetchTweets {
                        if let tweets = $0.data {
                            self?.decodeToTweetCellModel(tweets)
                        }
                    }
                }
			}
	}
	
	
	public func fetchNextPage() {
		print("(DEBUG) fetching next page!")
		fetchTweets(after: tweets?.last?.model?.id)
	}
	
	private func decodeToTweetCellModel(_ data: TweetSearchResult) {
		guard let tweets = data.data else { return }
		
        let fitleredTweet: [TweetCellModel] = tweets.compactMap { tweet in
			var model:TweetCellModel = .init(model: tweet)
			
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
