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
	
	public var view: AnyTableView?
	
	public func fetchHomePageData() {
		fetchTrendingHeadlines()
		fetchTopMentionedCoins()
		fetchVideo()
		view?.reloadTableWithDataSource(buildDataSource())
	}
	
	private func fetchTrendingHeadlines() {
		StubTrendingHeadlines.shared.fetchHeadlines { [weak self] result in
			switch result {
			case .success(let trendingResult):
				guard let validData = trendingResult.data else { return }
				self?.trendingHeadlines = validData
			case .failure(let err):
				print("(DEBUG) err : ",err.localizedDescription)
			}
		}
	}
	
	private func fetchTopMentionedCoins() {
		StubMentionService.shared.fetchMentions(period: .weekly) { [weak self] result in
			switch result {
			case .success(let result):
				guard let mentions = result.data?.all  else { return }
				self?.mentions = mentions
			case .failure(let err):
				print("(DEBUG) err : ",err.localizedDescription)
			}
		}
	}
	
	private func fetchVideo() {
		StubVideoService.shared.fetchVideo { [weak self] result in
			switch result {
			case .success(let videos):
				self?.videos = videos
			case .failure(let err):
				print("(DEBUG) err : ", err.localizedDescription)
			}
		}
	}
	
//MARK: - Sections
	private var trendingHeadlinesSection: TableSection? {
		guard let validTrendingHeadlines = trendingHeadlines else { return nil }
		let sectionHeader = "Trending Headlines".styled(font: .systemFont(ofSize: 25, weight: .semibold)).generateLabel.embedInView(insets: .init(vertical: 10, horizontal: 10))
		return .init(rows: validTrendingHeadlines.limitTo(to: 3).compactMap { TableRow<TrendingHeadlineCell>($0) }, customHeader: sectionHeader)
	}
	
	
	private var topMentionedCoinsSection: TableSection? {
		guard let validTopMentionedCoins = mentions else { return nil }
		let sectionHeader = "Top Mentioned Coins".styled(font: .systemFont(ofSize: 25, weight: .semibold)).generateLabel.embedInView(insets: .init(vertical: 10, horizontal: 10))
		return .init(rows: validTopMentionedCoins.limitTo(to: 5).compactMap { TableRow<TopMentionCell>($0) }, customHeader: sectionHeader)
	}
	
	private var videoSection: TableSection? {
		guard let videoSection = videos else { return nil }
		let sectionHeader = "Top Videos".styled(font: .systemFont(ofSize: 25, weight: .semibold)).generateLabel.embedInView(insets: .init(vertical: 10, horizontal: 10))
		return .init(rows: videoSection.compactMap { TableRow<VideoCell>($0) }, customHeader: sectionHeader)
	}
	
	private func buildDataSource() -> TableViewDataSource{
		.init(sections: [trendingHeadlinesSection, topMentionedCoinsSection, videoSection].compactMap { $0 })
	}
	

}
