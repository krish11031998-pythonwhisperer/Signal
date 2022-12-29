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
    
    //private lazy var scroll: UIScrollView = {.init()}()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
//    public var scrollOffset: PassthroughSubject<CGPoint,Never> = .init()
    //private var bag: Set<AnyCancellable> = .init()
    
    init(spacing: CGFloat = 8, ignoreSafeArea: Bool = false) {
        super.init(frame: .zero)
        stackView.spacing = spacing
        //scroll.contentInsetAdjustmentBehavior = ignoreSafeArea ? .never : .always
        setupView()
//        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
//        addSubview(scroll)
        //setFittingConstraints(childView: scroll, insets: .zero)
        addSubview(stackView)
        setFittingConstraints(childView: stackView, top: 0, leading: 0, trailing: 0, bottom: 0, centerX: 0)
    }
    
    func addArrangedView(view: UIView, additionalSpacing: CGFloat? = nil) {
        stackView.addArrangedSubview(view)
        if let spacing = additionalSpacing {
            stackView.setCustomSpacing(spacing, after: view)
        }
    }
    
//    func setupObservers() {
//        scrollOffset
//            .sink { [weak self] point in
//                self?.scroll.contentOffset = point
//            }
//            .store(in: &bag)
//    }
}

extension ScrollView {
    
//    var contentOffset: AnyPublisher<CGPoint,Never> {
//        self.publisher(for: \.contentOffset)
//            .eraseToAnyPublisher()
//    }
    
}
