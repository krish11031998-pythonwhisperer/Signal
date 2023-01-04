//
//  SegmentTabCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 04/01/2023.
//

import Foundation
import UIKit
import Combine

class SegmentTabCell<T>: UIView where T : RawRepresentable, T: Equatable {
    
    private lazy var text: UILabel = { .init() }()
    let value: T
    let subject: CurrentValueSubject<T, Never>
    
    init(value: T, subject: CurrentValueSubject<T, Never>) {
        self.value = value
        self.subject = subject
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = compressedSize.height.half
    }
    
    private func setupView() {
        (value.rawValue as? String)?.capitalized.body2Medium(color: .textColor).render(target: text)
        addSubview(text)
        setFittingConstraints(childView: text, insets: .init(by: 10))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        border(color: .textColor, borderWidth: 1)
    }
    
    
    func updateBlob() {
        if value == subject.value {
            backgroundColor = .surfaceBackgroundInverse
            text.textColor = .textColorInverse
        } else {
            backgroundColor = .clear
            text.textColor = .textColor
        }
    }
    
    
    @objc
    private func handleTap() {
        animate(.bouncy)
        subject.send(value)
    }
    
}
