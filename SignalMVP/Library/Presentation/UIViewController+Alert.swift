//
//  UIViewController+Alert.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 31/12/2022.
//

import Foundation
import UIKit
import Combine

extension UIViewController {
    
    func showAlert(title: String,
                   body: String,
                   buttonText: String? = nil,
                   handle: PassthroughSubject<(), Never>? = nil) {
        let target = AlertController(title: title,
                                     bodyText: body,
                                     buttonText: buttonText,
                                     handle: handle).withNavigationController()
        presentView(style: .sheet(size: .init(width: .totalWidth, height: 300), edge: .zero),
                    target: target,
                    onDimissal: nil)
    }
    
}