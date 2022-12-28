//
//  UITableView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 04/11/2022.
//

import Foundation
import UIKit

extension UITableView {
    
    var headerView: UIView? {
        get { tableHeaderView }
        set {
            let height = newValue?.compressedSize.height ?? 0
            tableHeaderView = newValue
            tableHeaderView?.frame = .init(origin: .zero, size: .init(width: .totalWidth, height: height))
        }
    }
    
}
