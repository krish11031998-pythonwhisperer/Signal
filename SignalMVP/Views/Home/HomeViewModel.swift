//
//  HomeViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit

protocol PresentDelegate {
    func presentView(origin: CGRect)
}

class HomeViewModel {
	
	private var trendingHeadlines: [TrendingHeadlinesModel]?
	private var mentions: [MentionModel]?
	private var videos: [VideoModel]?
	private var tweets: [TweetModel]?

	public var view: AnyTableView?
    public var viewTransitioner: PresentDelegate?
    
	public func fetchHomePageData() {
		let group = DispatchGroup()
		fetchTrendingHeadlines()
		fetchTopMentionedCoins()
		fetchVideo()
		fetchTweets(group)
		group.notify(queue: .main) { [weak self] in
			guard let validDatasource = self?.buildDataSource() else { return }
			self?.view?.reloadTableWithDataSource(validDatasource)
		}
	}
	
	private func fetchTrendingHeadlines() {
		StubTrendingHeadlines.shared.fetchHeadlines { [weak self] result in
            if let headlines = result.data?.data {
                self?.trendingHeadlines = headlines
            }
		}
	}
	
	private func fetchTopMentionedCoins() {
		StubMentionService.shared.fetchMentions(period: .weekly) { [weak self] result in
            if let mentions = result.data?.data?.all {
                self?.mentions = mentions
            }
		}
	}
	
	private func fetchVideo() {
		StubVideoService.shared.fetchVideo { [weak self] result in
            if let videos = result.data {
                self?.videos = videos
            }
		}
	}
	
	private func fetchTweets(_ group: DispatchGroup) {
		group.enter()
        TweetService.shared.fetchTweets { [weak self] result in
            if let tweets = result.data?.data {
                self?.tweets = tweets
            } else {
                StubTweetService.shared.fetchTweets { result in
                    if let data = result.data?.data {
                        self?.tweets = data
                    }
                }
            }
            group.leave()
        }
	}
	
//MARK: - Sections
	private var trendingHeadlinesSection: TableSection? {
		guard let validTrendingHeadlines = trendingHeadlines else { return nil }
		return .init(rows: validTrendingHeadlines.limitTo(to: 3).compactMap { TableRow<TrendingHeadlineCell>($0) }, title: "Trending Headlines")
	}
	
	
	private var topMentionedCoinsSection: TableSection? {
		guard let validTopMentionedCoins = mentions else { return nil }
        let topMentionedCoinsCellModel: [MentionCellModel] = validTopMentionedCoins.compactMap { mention in
                .init(model: mention) {
                    print("(DEBUG) Clicked : ", mention)
                    MentionStorage.selectedMention = mention
                }
        }
        return .init(rows: topMentionedCoinsCellModel.limitTo(to: 5).compactMap { TableRow<TopMentionCell>($0) }, title: "Top Mentioned Coins")
	}
	
	private var videoSection: TableSection? {
		guard let videoSection = videos else { return nil }
		return .init(rows: videoSection.limitTo(to: 3).compactMap { TableRow<VideoCell>($0) }, title: "Top Video News")
	}
	
	private var tweetsSection: TableSection? {
		guard let tweetsSection = tweets else { return nil }
		return .init(rows: tweetsSection.limitTo(to: 5).compactMap { TableRow<TweetCell>(.init(model: $0))}, title: "Top Tweets" )
	}
	
    private var storiesSection: TableSection? {
        guard let validMention = mentions else { return nil }
        let collectionCells = validMention.map { mention in
//            let origin: CGRect = .init(origin: .init(x: .totalWidth.half, y: .totalHeight.half), size: .init(squared: 64))
            let model: MentionCellModel = .init(model: mention, action: nil) { frame in
                self.handleTap(origin: frame, model: mention)
            }
            return CollectionItem<TopMentionStoryCell>(model)
        }
        return .init(rows: [TableRow<CollectionTableCell>(.init(cells: collectionCells, inset: .init(vertical: 0, horizontal: 10), cellSize: .init(squared: 64)))])
        
    }
    
    private func handleTap(origin: CGRect, model: MentionModel) {
        print("(DEBUG) handleTap! : ", origin)
        MentionStorage.selectedMention = model
        TopMentionStoryCell.visitedCells.insert(model)
        viewTransitioner?.presentView(origin: origin)
    }
    
    private var headerSection: TableSection? {
        return .init(rows: [TableRow<CustomCuratedEvents>(.init())])
    }
    
	private func buildDataSource() -> TableViewDataSource{
		.init(sections: [storiesSection, headerSection, trendingHeadlinesSection, topMentionedCoinsSection, tweetsSection, videoSection].compactMap { $0 })
	}
	

}
