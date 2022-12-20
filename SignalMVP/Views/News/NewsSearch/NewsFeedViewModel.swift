//
//  NewsFeedViewMOdel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 19/12/2022.
//

import Foundation
import Combine

fileprivate extension RoundedCardViewConfig {
    
    init(_ data: TickerInfo) {
        self.init(title: data.symbol?.body1Bold(),
                  subTitle: data.name?.body3Medium(color: .gray),
                  leadingView: .image(url: data.thumb,
                                      size: .init(squared: 48),
                                      cornerRadius: 24,
                                      bordered: true)
        )
    }
    
}

class NewsSearchViewModel {
    
    var searchParam: CurrentValueSubject<String?, Never> = .init(nil)
 
    struct Output {
        let searchResults: AnyPublisher<TableSection, Error>
    }
    
    func transform() -> Output {
        let searchResult = searchParam
            .compactMap { $0 }
            .filter { $0 != "" }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map { TickerService.shared.search(query: $0) }
            .switchToLatest()
            .map(setupSearchSection)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        return .init(searchResults: searchResult)
    }
    
    private func setupSearchSection(_ result: TickerSearchResult) -> TableSection {
        .init(rows: result.coins?.compactMap { TableRow<RoundedCardCell>(.init($0)) } ?? [])
    }
}
