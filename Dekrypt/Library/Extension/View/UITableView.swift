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
                asyncMain {
                    self.beginUpdates()
                    self.tableHeaderView = headerView
                    self.endUpdates()
                    self.tableHeaderView?.frame = .init(origin: .zero, size: .init(width: .totalWidth, height: headerView.compressedSize.height))
                    self.tableHeaderView?.alpha = 0
                    self.layoutIfNeeded()
                    self.tableHeaderView?.animate(.fadeIn())
                }
            } else {
                tableHeaderView?.animate(.fadeOut()) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
                        self.beginUpdates()
                        self.tableHeaderView = nil
                        self.endUpdates()
                        self.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
}
