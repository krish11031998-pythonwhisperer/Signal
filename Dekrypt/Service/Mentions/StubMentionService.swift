//
//  StubMentionService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import Combine

class StubMentionService: MentionsServiceInterface {
	
	public static let shared: StubMentionService = .init()

    public func fetchMentions(period: MentionPeriod) -> AnyPublisher<MentionsResult, Error> {
        Bundle.main.loadDataFromBundle(name: period.rawValue, extensionStr: "json")
    }
	
}
