//
//  LoadingIndicator.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 28/12/2022.
//

import Foundation
import UIKit
import Lottie

class LoadingIndicator: UIView {
    
    static let indicator = LoadingIndicator(frame: .init(origin: .zero, size: .init(squared: 40)))
    
    private lazy var loading: AnimationView = { .init(name: "loading") }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(loading)
        loading.frame = bounds
        loading.center = center
        loading.loopMode = .loop
    }
    
    func start(origin: CGPoint = .zero) {
        frame.origin = origin
        loading.play()
    }
    
    func stop() {
        loading.stop()
        removeFromSuperview()
    }
}
