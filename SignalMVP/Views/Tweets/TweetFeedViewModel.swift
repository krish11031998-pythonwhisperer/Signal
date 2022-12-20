//
//  TweetFeedViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import Combine

fileprivate extension Array where Element == TweetCellModel {
    var lastID: String? {
        last?.model?.id
    }
}

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
    func reloadSection(_ section: TableSection, at sectionIdx: Int?)
}

extension AnyTableView {
    func reloadSection(_ section: TableSection, at sectionIdx: Int? = nil) {}
}

class TweetFeedViewModel {

	var tweets: [TweetCellModel]?
	var loading: Bool = false
	var view: AnyTableView?
    private var bag: Set<AnyCancellable> = .init()
    @Published var selectedTweet: TweetCellModel?
    
	public func fetchTweets(entity: String? = nil, before: String? = nil, after: String? = nil, limit: Int = 20) {
		guard !loading else { return }
		loading = true
		TweetService
			.shared
            .fetchTweets(after: after)
            .catch { err in
                print("(ERROR) TweetService : ", err.localizedDescription)
                return StubTweetService.shared.fetchTweets()
            }
            .sink { err in
                switch err {
                case .failure(let err):
                    print("(DEBUG) err: ", err)
                default: break
                }
            } receiveValue: { [weak self] tweets in
                self?.decodeToTweetCellModel(tweets)
            }
            .store(in: &bag)

	}
	
	
	public func fetchNextPage() {
        guard let id = tweets?.lastID, !loading else { return }
        print("(DEBUG) fetching next page! : ", id)
		fetchTweets(after: id)
	}
	
	private func decodeToTweetCellModel(_ data: TweetSearchResult) {
		guard let tweets = data.data else { return }
		
        let fitleredTweet: [TweetCellModel] = tweets.compactMap { tweet in
			var model:TweetCellModel = .init(model: tweet)
			
			model.action = {
                self.selectedTweet = model
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
