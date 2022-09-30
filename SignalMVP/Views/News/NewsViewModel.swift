//
//  NewsViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation

struct NewsCellModel: ActionProvider {
	let model: NewsModel
	var action: Callback?
}

class NewsViewModel {
	
	var view: AnyTableView?
	var news: [NewsModel]?
	
	func fetchNews() {
		NewsService
			.shared
			.fetchNews { [weak self] result in
			switch result {
			case .success(let news):
				self?.news = news.data
				DispatchQueue.main.async {
					guard let source = self?.buildTableViewSource() else {
						return
					}
					
					self?.view?.reloadTableWithDataSource(source)
				}
			case .failure(let err):
				print("(Error) err : ",err.localizedDescription)
			}
		}
	}
	
	var newsSection: TableSection? {
		guard let validNews = news else { return nil }
		let rows = validNews.compactMap { news in
			TableRow<NewsCell>(.init(model: news, action: {
				NewsStorage.selectedNews = news
			})) }
		return .init(rows: rows)
	}
	
	func buildTableViewSource() -> TableViewDataSource {
		return .init(sections: [newsSection].compactMap { $0 })
	}
	
}
