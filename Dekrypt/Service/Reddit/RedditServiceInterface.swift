//
//  RedditServiceInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation

protocol RedditServiceInterface {
	func fetchRedditPosts(completion: @escaping (Result<[RedditPostModel],Error>) -> Void)
}
