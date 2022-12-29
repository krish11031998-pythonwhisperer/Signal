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
    
    
    var animateHeaderView: UIView? {
        get { tableHeaderView }
        set {
            if let headerView = newValue {
                tableHeaderView = headerView
                tableHeaderView?.frame = .init(origin: .zero, size: .init(width: .totalWidth, height: headerView.compressedSize.height))
                tableHeaderView?.alpha = 0
                setNeedsLayout()
                tableHeaderView?.animate(.fadeIn())
            } else {
                tableHeaderView?.animate(.fadeOut()) {
                    self.tableHeaderView = nil
                    self.setNeedsLayout()
                }
            }
        }
    }
    
}
