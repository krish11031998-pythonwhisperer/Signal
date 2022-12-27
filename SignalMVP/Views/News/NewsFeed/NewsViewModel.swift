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
    private var nextPage: Int = 0
    private var news: [NewsModel]?
    
    struct Input {
        let searchParam: CurrentValueSubject<String?, Never>
        let nextPage: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        let tableSection: AnyPublisher<TableSection, Error>
        let dismissSearch: AnyPublisher<Bool, Never>
    }
    
    func transform(input: Input) -> Output {
        
        let newPage = input.nextPage
            .removeDuplicates()
            .filter { [weak self] in $0 && self?.nextPage != nil }
            .withLatestFrom(input.searchParam)
            .flatMap { [weak self] in NewsService.shared.fetchNews(entity: [$0.1].compactMap { $0 },
                                                                   page: self?.nextPage ?? 0) }
            .catch { _ in StubNewsService.shared.fetchNews() }
            .compactMap { $0.data }
            .compactMap { [weak self] in self?.setupSection($0, append: true) }
            .eraseToAnyPublisher()
        
        let searchResult = input.searchParam
            .flatMap{ NewsService.shared.fetchNews(entity: [$0].compactMap { $0 }) }
            .catch { _ in StubNewsService.shared.fetchNews() }
            .compactMap { $0.data }
            .compactMap { [weak self] in self?.setupSection($0, append: false) }
            .eraseToAnyPublisher()
        
        
        let news = Publishers.Merge(newPage, searchResult).eraseToAnyPublisher()
        
        let dismiss = input.searchParam
            .compactMap { $0 == nil }
            .eraseToAnyPublisher()
    
        return .init(tableSection: news, dismissSearch: dismiss)
    }
    
    private func getNextPageToken(_ allNews: [NewsModel]) {
        guard !allNews.isEmpty else { return }
        nextPage += 1
    }
    
    func setupSection(_ allNews: [NewsModel], append: Bool = true) -> TableSection {
        getNextPageToken(allNews)
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
        
        if !append || self.news == nil {
            self.news = allNews
        } else if append {
            self.news?.append(contentsOf: allNews)
        }
        
        let rows = (self.news ?? []).compactMap { news in
            TableRow<NewsCell>(.init(model: news, action: { self.selectedNews.send(news) }))
        }
        return TableSection(rows: selectedCurrency + rows)
    }
}
