//
//  UITabbar.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/11/2022.
//

import Foundation
import UIKit

extension UITabBar {
    
    var hide: Bool {
        get { isHidden }
        set {
            
            if newValue {
                animate(.slide(.down, state: .out, duration: 0.5)) {
                    self.isHidden = newValue
                }
            } else {
                self.isHidden = newValue
                animate(.slide(.down, state: .in, duration: 0.5))
            }
        }
    }
    
}
