//
//  PublishersExtension.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 28/12/2022.
//

import Foundation
import Combine

typealias SharePublisher<T,E: Error> = Publishers.MakeConnectable<Publishers.Share<AnyPublisher<T,E>>>
