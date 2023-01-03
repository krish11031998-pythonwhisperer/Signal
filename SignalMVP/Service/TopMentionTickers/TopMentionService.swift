//
//  TopMentionService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 03/01/2023.
//

import Foundation
import Combine
class TopMentionService: TopMentionServiceInterface {
    
    func fetchTopMention(page: Int? = nil,
                         limt: Int? = nil) -> AnyPublisher<MentionsResult, Error>{
        TopMentionEndpoint
            .topMentionTickers(page: page, limit: limt)
            .execute()
            .eraseToAnyPublisher()
    }
}
