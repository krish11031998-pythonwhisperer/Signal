//
//  HomeViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation


class HomeViewModel {
	
	private var trendingHeadlines: [TrendingHeadlinesModel]?
	private var mentions: [MentionModel]?
	private var videos: [VideoModel]?
	private var tweets: [TweetModel]?
	
	public var view: AnyTableView?
	
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
		let sectionHeader = "Trending Headlines".heading2().generateLabel.embedInView(insets: .init(vertical: 10, horizontal: 10))
		return .init(rows: validTrendingHeadlines.limitTo(to: 3).compactMap { TableRow<TrendingHeadlineCell>($0) }, customHeader: sectionHeader)
	}
	
	
	private var topMentionedCoinsSection: TableSection? {
		guard let validTopMentionedCoins = mentions else { return nil }
		let sectionHeader = "Top Mentioned Coins".heading2().generateLabel.embedInView(insets: .init(vertical: 10, horizontal: 10))
		return .init(rows: validTopMentionedCoins.limitTo(to: 5).compactMap { TableRow<TopMentionCell>($0) }, customHeader: sectionHeader)
	}
	
	private var videoSection: TableSection? {
		guard let videoSection = videos else { return nil }
		let sectionHeader = "Top Video News".heading2().generateLabel.embedInView(insets: .init(vertical: 10, horizontal: 10))
		return .init(rows: videoSection.limitTo(to: 3).compactMap { TableRow<VideoCell>($0) }, customHeader: sectionHeader)
	}
	
	private var tweetsSection: TableSection? {
		guard let tweetsSection = tweets else { return nil }
		let sectionHeader = "Top Tweets".heading2().generateLabel.embedInView(insets: .init(vertical: 10, horizontal: 10))
		return .init(rows: tweetsSection.limitTo(to: 5).compactMap { TableRow<TweetCell>(.init(model: $0))}, customHeader: sectionHeader )
	}
	
    private var headerSection: TableSection? {
        return .init(rows: [TableRow<CustomCuratedEvents>(.init())])
    }
    
	private func buildDataSource() -> TableViewDataSource{
		.init(sections: [headerSection, trendingHeadlinesSection, topMentionedCoinsSection, tweetsSection, videoSection].compactMap { $0 })
	}
	

}
