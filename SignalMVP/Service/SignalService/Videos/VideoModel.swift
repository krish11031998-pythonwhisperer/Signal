//
//  VideoModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation

typealias VideoModel = NewsModel

struct VideoResult: Codable {
	let data: [VideoModel]
}
