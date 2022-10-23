//
//  Fundamentals.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/10/2022.
//

import Foundation
import UIKit

func asyncMain(completion: @escaping Callback) {
    DispatchQueue.main.async(execute: completion)
}

var isDebug: Bool = true
