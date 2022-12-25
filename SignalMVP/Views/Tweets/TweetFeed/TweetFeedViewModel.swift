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

//MARK: - TweetFeedViewModel
class TweetFeedViewModel {

	var tweets: [TweetCellModel]?
    var loading: CurrentValueSubject<Bool, Never> = .init(false)
	var view: AnyTableView?
    private var bag: Set<AnyCancellable> = .init()
    @Published var selectedTweet: TweetCellModel?
    
    private var after: CurrentValueSubject<String?, Never> = .init(nil)
    
    struct Input {
        let searchParam: AnyPublisher<String?, Never>
    }
    
    struct Output {
        let sections: AnyPublisher<TableSection, Error>
    }
    
    public func transform(input: Input) -> Output {
        
        let sections = loading
            .filter { $0 }
            .combineLatest(input.searchParam, after) { _, search, after in
                (search, after)
            }
            .flatMap {
                TweetService.shared.fetchTweets(entity: $0.0, after: $0.1)
            }
            .catch {
                print("(ERROR) TweetService Error: ", $0.localizedDescription)
                return StubTweetService.shared.fetchTweets()
            }
            .compactMap {[weak self] in
                self?.decodeToTweetCellModel($0)
            }
            .eraseToAnyPublisher()
        
        return .init(sections: sections)
    }
    
	
	
	public func fetchNextPage() {
        guard let id = tweets?.lastID, !loading.value else { return }
        after.send(id)
        loading.send(true)
        print("(DEBUG) fetching next page! : ", id)
	}
	
	private func decodeToTweetCellModel(_ data: TweetSearchResult) -> TableSection? {
		guard let tweets = data.data else { return nil }
		
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
		
        loading.send(false)
        return tweetSection
		
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
