//
//  UIScrollView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 27/12/2022.
//

import Foundation
import UIKit
import Combine

extension UIScrollView {
    
    var nextPage: AnyPublisher<Bool, Never> {
        publisher(for: \.contentOffset)
            .compactMap { [weak self] in
                guard let self,
                      self.contentSize.height > .totalHeight
                else { return false }
                return  $0.y >=  self.contentSize.height - self.frame.height
            }
            .eraseToAnyPublisher()
    }
    
    
}
