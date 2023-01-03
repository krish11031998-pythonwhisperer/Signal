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
    
    init(tickers: [MentionTickerModel]) {
        self.tickers = tickers
    }
    
    struct Output {
        let section: AnyPublisher<[TableSection], Never>
    }
    
    func transform() -> Output {
        let sections = Just(tickers)
            .compactMap {
                $0.compactMap { ticker in
                    let model: MentionCellModel = .init(model: ticker)
                    return TableRow<TopMentionCell>(model)
                }
            }
            .compactMap { [TableSection(rows: $0)] }
            .eraseToAnyPublisher()
        
        return .init(section: sections)
    }
    
}
