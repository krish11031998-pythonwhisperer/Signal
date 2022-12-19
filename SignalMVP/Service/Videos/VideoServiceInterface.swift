//
//  VideoInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import Combine

protocol VideoServiceInterface {
    func fetchVideo() -> Future<VideoResult,Error>
}
