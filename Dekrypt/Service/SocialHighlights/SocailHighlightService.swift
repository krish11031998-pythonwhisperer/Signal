//
//  SocailHighlightService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/12/2022.
//

import Foundation
import Combine

class SocialHighlightService: SocialHighlightServiceInterface {
    
    static var shared: SocialHighlightService = .init()
    
    func fetchSocialHighlight() -> AnyPublisher<SocialHighlightResult, Error> {
        SocialHighlightEndpoint
            .fetchSocialHighlights()
            .execute()
            .eraseToAnyPublisher()
    }
}
