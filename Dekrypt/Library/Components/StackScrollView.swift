//
//  StackScrollView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 19/11/2022.
//

import Foundation
import UIKit
import Combine

class ScrollView: UIScrollView {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    private let axis: NSLayoutConstraint.Axis
    init(spacing: CGFloat = 8, ignoreSafeArea: Bool = false, axis: NSLayoutConstraint.Axis = .vertical) {
        self.axis = axis
        super.init(frame: .zero)
        stackView.spacing = spacing
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(stackView)
        stackView.axis = axis
        switch axis {
        case .horizontal:
            setFittingConstraints(childView: stackView, top: 0, leading: 0, trailing: 0, bottom: 0, centerY: 0)
        case .vertical:
            setFittingConstraints(childView: stackView, top: 0, leading: 0, trailing: 0, bottom: 0, centerX: 0)
        }
        
    }
    
    func addArrangedView(view: UIView, additionalSpacing: CGFloat? = nil) {
        stackView.addArrangedSubview(view)
        if let spacing = additionalSpacing {
            stackView.setCustomSpacing(spacing, after: view)
        }
    }
}
