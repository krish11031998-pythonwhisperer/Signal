//
//  DualLabel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 31/12/2022.
//

import Foundation
import UIKit

class DualLabel: UIView {
    
    private lazy var title: UILabel = { .init() }()
    private lazy var subTitle: UILabel = { .init() }()
    private let spacing: CGFloat
    private let alignment: UIStackView.Alignment
    
    init(spacing: CGFloat, alignment: UIStackView.Alignment) {
        self.spacing = spacing
        self.alignment = alignment
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stack: UIStackView = .VStack(subViews: [title, subTitle], spacing: spacing, alignment: alignment)
        addSubview(stack)
        setFittingConstraints(childView: stack, insets: .zero)
    }
    
    func configure(title: RenderableText?, subtitle: RenderableText?) {
        title?.render(target: self.title)
        subtitle?.render(target: self.subTitle)
    }
    
}
