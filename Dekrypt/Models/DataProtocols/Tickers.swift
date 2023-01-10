//
//  Tickers.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 13/12/2022.
//

import Foundation

protocol Tickers: Codable {
    var tickers: [String]? { get set }
}
