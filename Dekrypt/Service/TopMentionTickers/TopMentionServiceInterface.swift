//
//  TopMentionServiceInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 03/01/2023.
//

import Foundation
import Combine

protocol TopMentionServiceInterface {
    func fetchTopMention(page: Int?, limt: Int?) -> AnyPublisher<MentionsResult, Error>
}
