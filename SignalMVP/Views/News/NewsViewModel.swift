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
    
    var news: AnyPublisher<TableSection, Never> {
        NewsService.shared
            .fetchNews()
            .catch { err in
                print("(DEBUG) err : ", err)
                return StubNewsService.shared.fetchNews()
            }
            .catch({ _ in
                Just(NewsResult(data: []))
            })
            .compactMap { $0.data }
            .map { allNews in
                let rows = allNews.compactMap { news in
                    TableRow<NewsCell>(.init(model: news, action: { self.selectedNews.send(news) }))
                }
                return TableSection(rows: rows)
            }
            .eraseToAnyPublisher()
    }
}
