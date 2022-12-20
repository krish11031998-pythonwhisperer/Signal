//
//  RoundedCardCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/12/2022.
//

import Foundation
import UIKit

class RoundedCardCell: ConfigurableCell {
    
    private lazy var card: RoundedCardView = { .init() }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(card)
        contentView.setFittingConstraints(childView: card, insets: .init(vertical: 5, horizontal: 5))
        backgroundColor = .clear
        card.backgroundColor = .surfaceBackground.withAlphaComponent(0.5)
        
    }
    
    func configure(with model: RoundedCardViewConfig) {
        card.configureView(with: model)
    }
}
