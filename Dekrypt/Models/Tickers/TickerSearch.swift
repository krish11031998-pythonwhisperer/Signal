//
//  TickerSearch.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/12/2022.
//

import Foundation
import UIKit

public struct TickerInfo: Codable {
    let id: String?
    let name: String?
    let apiSymbol: String?
    let symbol: String?
    let marketCapRank: Int?
    let thumb: String?
    let large: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol, thumb, large
        case apiSymbol = "api_symbol"
        case marketCapRank = "market_cap_rank"
    }
}


public struct TickerSearchResult: Codable {
    let coins: [TickerInfo]?
}

struct TickerInfoItem: Codable {
    let item: TickerInfo
}

public struct TickerSearchTrendingResult: Codable {
    let coins: [TickerInfoItem]?
}
