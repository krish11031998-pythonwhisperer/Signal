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
}


public struct TickerSearchResult: Codable {
    let coins: [TickerInfo]?
}
