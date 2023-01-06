//
//  StubRedditService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation

class StubRedditService: RedditServiceInterface {
	
	public static var shared: StubRedditService = .init()
	
	public func fetchRedditPosts(completion: @escaping (Result<[RedditPostModel],Error>) -> Void) {
		let result: Result<RedditPostResult,Error> = Bundle.main.loadDataFromBundle(name: "reddit", extensionStr: "json")
		switch result {
		case .success(let success):
			let post = Array(success.data.values)
			if post.isEmpty {
				completion(.failure(URLSessionError.noData))
			} else {
				completion(.success(post))
			}
		case .failure(let failure):
			completion(.failure(failure))
		}
	}
}
