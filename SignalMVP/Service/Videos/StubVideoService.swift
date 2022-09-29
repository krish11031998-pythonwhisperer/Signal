//
//  StubVideoService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation


class StubVideoService: VideoServiceInterface {
	
	public static let shared: StubVideoService = .init()
	
	public func fetchVideo(completion: @escaping (Result<[VideoModel],Error>) -> Void) {
		let result: Result<VideoResult,Error> = Bundle.main.loadDataFromBundle(name: "videos", extensionStr: "json")
		switch result {
		case .success(let success):
			guard !success.data.isEmpty else {
				completion(.failure(URLSessionError.noData))
				return
			}
			completion(.success(success.data))
		case .failure(let failure):
			completion(.failure(failure))
		}
	}
	
}
