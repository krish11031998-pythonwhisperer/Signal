//
//  StubMentionService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation

class StubMentionService: MentionsServiceInterface {
	
	public static let shared: StubMentionService = .init()
	
	public func fetchMentions(period: MentionPeriod, completion: @escaping (Result<MentionsResult, Error>) -> Void) {
		completion(Bundle.main.loadDataFromBundle(name: period == .weekly ? "topMentionsWeek" : "topMentionsMonth", extensionStr: "json"))
	}
	
}
