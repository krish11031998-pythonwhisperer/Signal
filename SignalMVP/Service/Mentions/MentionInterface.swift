//
//  Mentions.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation

protocol MentionsServiceInterface {
	func fetchMentions(period: MentionPeriod, completion: @escaping (Result<MentionsResult, Error>) -> Void)
}
