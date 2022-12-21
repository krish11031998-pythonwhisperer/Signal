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
    
    struct Input {
        let searchParam: CurrentValueSubject<String?, Never>
    }
    
    struct Output {
        let tableSection: AnyPublisher<TableSection, Error>
        let dismissSearch: AnyPublisher<Bool, Never>
    }
    
    func transform(input: Input) -> Output {
        let news = input.searchParam
            .flatMap({
                return NewsService.shared.fetchNews(tickers: $0)
            })
            .catch({ _ in
                return StubNewsService.shared.fetchNews()
            })
            .compactMap { $0.data }
            .map(setupSection)
            .eraseToAnyPublisher()
        
        let dismiss = input.searchParam
            .compactMap { $0 == nil }
            .eraseToAnyPublisher()
    
        return .init(tableSection: news, dismissSearch: dismiss)
    }
    
    func setupSection(_ allNews: [NewsModel]) -> TableSection {
        
        var selectedCurrency: [TableCellProvider] = []
        if let currency = searchParam.value, !currency.isEmpty {
            let image: RoundedCardViewSideView = .image(url: currency.logoURL,
                                                        size: .init(squared: 48),
                                                        cornerRadius: 24,
                                                        bordered: false)
            selectedCurrency = [TableRow<RoundedCardCell>(.init(model: .init(title: "Selected Currency".body2Medium(color: .gray),
                                                                             subTitle: currency.body1Bold(),
                                                                             leadingView: image)))]
        }
        
        let rows = allNews.compactMap { news in
            TableRow<NewsCell>(.init(model: news, action: { self.selectedNews.send(news) }))
        }
        return TableSection(rows: selectedCurrency + rows)
    }
}
