//
//  SocialHighlightInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/12/2022.
//

import Foundation
import Combine

protocol SocialHighlightServiceInterface {
    func fetchSocialHighlight() -> AnyPublisher<SocialHighlightResult, Error>
}
