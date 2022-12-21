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
                  caption: "Rank".body3Medium(),
                  subCaption: "\(data.marketCapRank ?? -1)".body2Medium(),
                  leadingView: .image(url: data.large,
                                      size: .init(squared: 48),
                                      cornerRadius: 24,
                                      bordered: true)
        )
    }
    
}

class NewsSearchViewModel {
    
    let selectedCurrency: CurrentValueSubject<String?, Never>
    
    init(selectedCurrency: CurrentValueSubject<String?, Never>) {
        self.selectedCurrency = selectedCurrency
    }
    
    var searchParam: CurrentValueSubject<String?, Never> = .init(nil)
 
    struct Output {
        let searchResults: AnyPublisher<TableSection, Error>
    }
    
    func transform() -> Output {
        let searchResult = searchParam
            .compactMap { $0 }
            .filter { $0 != "" }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { TickerService.shared.search(query: $0) }
            .switchToLatest()
            .map(setupSearchSection)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        return .init(searchResults: searchResult)
    }
    
    private func setupSearchSection(_ result: TickerSearchResult) -> TableSection {
        guard let coins = result.coins else {
            return .init(rows: [])
        }
        
        return .init(rows: coins.compactMap { ticker in
            let model = RoundedCardViewConfig(ticker)
            let action: Callback? = {
                self.selectedCurrency.send(ticker.symbol ?? "")
            }
            
            return TableRow<RoundedCardCell>(.init(model: model, action: action))
        })
    }
}
