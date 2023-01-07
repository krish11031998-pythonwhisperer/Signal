//
//  PublishersExtension.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 28/12/2022.
//

import Foundation
import Combine

typealias SharePublisher<T,E: Error> = Publishers.MakeConnectable<Publishers.Share<AnyPublisher<T,E>>>
typealias ConnectablePublisher<T,E: Error> = Publishers.MakeConnectable<AnyPublisher<T, E>>
typealias StringPublisher<E: Error> = AnyPublisher<String, E>
typealias BoolPublisher<E: Error> = AnyPublisher<Bool, E>
typealias IntPublisher<E: Error> = AnyPublisher<Int, E>
typealias VoidPublisher = AnyPublisher<Void, Never>
