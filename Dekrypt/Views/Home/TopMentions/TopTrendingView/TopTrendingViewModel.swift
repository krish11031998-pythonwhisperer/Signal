//
//  TopTrendingViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 03/01/2023.
//

import Foundation
import Combine

class TopTrendingViewModel {
    
    let tickers: [MentionTickerModel]
    private let navigation: PassthroughSubject<Navigation, Never> = .init()
    
    enum Navigation {
        case toTickerDetail(_ mention: MentionTickerModel)
    }
    
    init(tickers: [MentionTickerModel]) {
        self.tickers = tickers
    }
    
    struct Output {
        let section: AnyPublisher<[TableSection], Never>
        let navigation: AnyPublisher<Navigation, Never>
    }
    
    func transform() -> Output {
        let sections = Just(tickers)
            .compactMap { [weak self] in
                $0.compactMap { ticker in
                    let model: MentionCellModel = .init(model: ticker) {
                        self?.navigation.send(.toTickerDetail(ticker))
                    }
                    return TableRow<TopMentionCell>(model)
                }
            }
            .compactMap { [TableSection(rows: $0)] }
            .eraseToAnyPublisher()
        
        return .init(section: sections, navigation: navigation.eraseToAnyPublisher())
    }
    
}
