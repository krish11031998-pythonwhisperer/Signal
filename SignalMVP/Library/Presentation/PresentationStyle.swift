//
//  PresentationStyle.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 13/11/2022.
//

import Foundation
import UIKit

//MARK: - PresentationStyle
enum PresentationStyle {
    case circlar(frame: CGRect)
    case sheet(size: CGSize = .init(width: .totalWidth, height: .totalHeight), edge: UIEdgeInsets = .zero)
    case dynamic
}

extension PresentationStyle {
    func originalFrame(view: UIViewController) -> CGRect {
        switch self {
        case .circlar(let size):
            return size
        case .sheet(let size, _):
            return .init(origin: .init(x: .zero, y: .totalHeight), size: size)
        case .dynamic:
            return .init(origin: .init(x: .zero, y: .totalHeight), size: .init(width: .totalWidth, height: view.compressedSize.height))
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .circlar(let frame):
            return frame.size.smallDim.half
        case .sheet, .dynamic:
            return 0
        }
    }
    
    func frameOfPresentedView(view: UIViewController) -> CGRect {
        switch self {
        case .circlar:
            return .init(origin: .zero, size: .init(width: .totalWidth, height: .totalHeight))
        case .sheet(let size, let edge):
            return .init(origin: .init(x: .zero, y: .totalHeight - size.height), size: .init(width: size.width, height: size.height - edge.bottom))
        case .dynamic:
            let y: CGFloat = .totalHeight - view.compressedSize.height
            return .init(origin: .init(x: .zero, y: y), size: .init(width: .totalWidth, height: view.compressedSize.height))
        }
    }
    
    var initScale: CGFloat {
        switch self {
        case .circlar:
            return 0.9
        case .sheet, .dynamic:
            return 1
        
        }
    }
    
    var transitionDuration: TimeInterval {
        switch self {
        case .circlar:
            return 0.2
        case .sheet, .dynamic:
            return 0.25
        }
    }
    
    var removeView: Bool {
        switch self {
        case .circlar:
            return true
        case .sheet, .dynamic:
            return false
        }
    }
    
    var addDimmingView: Bool {
        switch self {
        case .circlar, .sheet:
            return false
        default:
            return true
        }
    }
}
