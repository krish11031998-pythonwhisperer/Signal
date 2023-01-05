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
    private var nextPageId: Int = 0
    
    struct Input {
        let refresh: AnyPublisher<String?, Never>
        let searchParam: SharePublisher<String?, Never>
        let loadNextPage: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        let sections: AnyPublisher<TableSection, Error>
    }
    
    public func transform(input: Input) -> Output {

        let searchResults = input.searchParam
            .flatMap {
                let search = $0 ?? ""
                return TweetService.shared.fetchTweetsForAllTickers(entity: $0, refresh: !search.isEmpty)
            }
            .compactMap { [weak self] in self?.decodeToTweetCellModel($0, append: false) }
            .eraseToAnyPublisher()
        
        let loadNextPage = input.loadNextPage
            .removeDuplicates()
            .filter {[weak self] in $0 && self?.nextPageId != nil }
            .withLatestFrom(input.searchParam)
            .flatMap {[weak self] in TweetService.shared.fetchTweetsForAllTickers(entity: $0.1, page: self?.nextPageId ?? 0, refresh: true) }
            .compactMap {[weak self] in  self?.decodeToTweetCellModel($0) }
            .eraseToAnyPublisher()
        
        let refresh = input.refresh
            .flatMap { TweetService.shared.fetchTweetsForAllTickers(entity: $0, refresh: true) }
            .compactMap { [weak self] in self?.decodeToTweetCellModel($0, append: false) }
            .eraseToAnyPublisher()
        
        
        let sections = Publishers.Merge3(searchResults, refresh, loadNextPage).eraseToAnyPublisher()
        
        
        return .init(sections: sections)
    }
    
    private func getNextPageToken(result: TweetResult) {
        guard let lastId = result.data?.count, lastId > 0 else { return }
        nextPageId += 1
    }
    
    private func decodeToTweetCellModel(_ data: TweetResult, append: Bool = true) -> TableSection {
        getNextPageToken(result: data)
        guard let tweets = data.data else { return .init(rows: []) }
        let fitleredTweet: [TweetCellModel] = tweets.compactMap { tweet in
			var model:TweetCellModel = .init(model: tweet)
			model.action = {
                self.selectedTweet = model
			}
			return model
		}
	
		if self.tweets == nil || !append {
			self.tweets = fitleredTweet
		} else if append {
			print("(DEBUG) Adding newTweets")
			self.tweets?.append(contentsOf: fitleredTweet)
		}
    
        return tweetSection ?? .init(rows: [])
		
	}
	
	private var tweetSection: TableSection? {
		guard let validTweets = tweets else { return nil }
		let rows = validTweets.compactMap { TableRow<TweetCell>($0) }
		return .init(rows: rows)
	}
}
