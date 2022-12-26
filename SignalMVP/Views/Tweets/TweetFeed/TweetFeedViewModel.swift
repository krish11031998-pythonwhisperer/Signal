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
    private var nextPageId: String?
    
    struct Input {
        let searchParam: AnyPublisher<String?, Never>
        let loadNextPage: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        let sections: AnyPublisher<TableSection, Error>
    }
    
    public func transform(input: Input) -> Output {
        
//        let page = after
//            .print("Fetching Next page!")
//            .withLatestFrom(input.searchParam)
//            .flatMap { TweetService.shared.fetchTweets(entity: $0.0, after: $0.1) }
//            .catch { _ in StubTweetService.shared.fetchTweets() }
//            .handleEvents(receiveOutput: { [weak self] in self?.getNextPageToken(result: $0) })
//            .compactMap {[weak self] in  self?.decodeToTweetCellModel($0) }
//            .eraseToAnyPublisher()
        
        let searchResults = input.searchParam
            .flatMap { TweetService.shared.fetchTweets(entity: $0) }
            .catch { _ in StubTweetService.shared.fetchTweets() }
            .handleEvents(receiveOutput: { [weak self] in self?.getNextPageToken(result: $0) })
            .compactMap { [weak self] in self?.decodeToTweetCellModel($0, append: false) }
            .eraseToAnyPublisher()
        
        let loadNextPage = input.loadNextPage
            .removeDuplicates()
            .filter { $0 }
            .withLatestFrom(input.searchParam)
            .flatMap {[weak self] in TweetService.shared.fetchTweets(entity: $0.1, after: self?.nextPageId) }
            .catch { _ in StubTweetService.shared.fetchTweets() }
            .handleEvents(receiveOutput: { [weak self] in self?.getNextPageToken(result: $0) })
            .compactMap {[weak self] in  self?.decodeToTweetCellModel($0) }
            .eraseToAnyPublisher()
        
        let sections = Publishers.Merge(searchResults, loadNextPage).eraseToAnyPublisher()
        
        
        return .init(sections: sections)
    }
    
    private func getNextPageToken(result: TweetSearchResult) {
        guard let lastId = result.data?.last?.id else { return }
        nextPageId = lastId
    }
    
    private func decodeToTweetCellModel(_ data: TweetSearchResult, append: Bool = true) -> TableSection? {
		guard let tweets = data.data else { return nil }
        let fitleredTweet: [TweetCellModel] = Set(tweets).compactMap { tweet in
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
