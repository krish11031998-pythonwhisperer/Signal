//
//  NewsViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine

struct NewsCellModel: ActionProvider {
	let model: NewsModel
	var action: Callback?
}

class NewsViewModel {
	
	var view: AnyTableView?
	var news: [NewsModel]?
    var selectedNews: CurrentValueSubject<NewsModel?, Never> = .init(nil)
	
	func fetchNews() {
        StubNewsService
            .shared
			.fetchNews { [weak self] result in
                if let news = result.data?.data {
                    self?.news = news
                    asyncMain {
                        guard let strongSelf = self else { return }
                        strongSelf.view?.reloadTableWithDataSource(strongSelf.buildTableViewSource())
                    }
                }
		}
	}
	
	var newsSection: TableSection? {
		guard let validNews = news else { return nil }
		let rows = validNews.compactMap { news in
			TableRow<NewsCell>(.init(model: news, action: {
//				NewsStorage.selectedNews = news
                self.selectedNews.value = news
			})) }
		return .init(rows: rows)
	}
	
	func buildTableViewSource() -> TableViewDataSource {
		return .init(sections: [newsSection].compactMap { $0 })
	}
	
}
