//
//  StoryServiceInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 06/01/2023.
//

import Foundation
import Combine

protocol StoryServiceInterface {
    func fetchStory(ticker: String) -> AnyPublisher<StoryDataResult, Error>
}
