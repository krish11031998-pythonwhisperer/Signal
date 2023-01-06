//
//  Mentions.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import Combine

protocol MentionsServiceInterface {
    func fetchMentions(period: MentionPeriod) -> AnyPublisher<MentionsResult, Error>
}
