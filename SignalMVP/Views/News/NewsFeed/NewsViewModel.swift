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
	
    var selectedNews: CurrentValueSubject<NewsModel?, Never> = .init(nil)
    private var bag: Set<AnyCancellable> = .init()
    var searchParam: CurrentValueSubject<String?, Never> = .init(nil)
        
    struct Output {
        let tableSection: AnyPublisher<TableSection, Error>
    }
    
    func transform() -> Output {
        let news = searchParam
            .map {
                print("(DEBUG) symbol to search: ", $0)
                return NewsService.shared.fetchNews(tickers: $0)
            }
            .switchToLatest()
            .catch { err in
                print("(ERROR) err : ", err)
                return StubNewsService.shared.fetchNews()
            }
            .compactMap { $0.data }
            .map(setupSection)
            .eraseToAnyPublisher()
    
        return .init(tableSection: news)
    }
    
    func setupSection(_ allNews: [NewsModel]) -> TableSection {
        let rows = allNews.compactMap { news in
            TableRow<NewsCell>(.init(model: news, action: { self.selectedNews.send(news) }))
        }
        return TableSection(rows: rows)
    }
}
