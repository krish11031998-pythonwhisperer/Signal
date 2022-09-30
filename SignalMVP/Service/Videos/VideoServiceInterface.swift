//
//  VideoInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation

protocol VideoServiceInterface {
	func fetchVideo(completion: @escaping (Result<[VideoModel],Error>) -> Void)
}
