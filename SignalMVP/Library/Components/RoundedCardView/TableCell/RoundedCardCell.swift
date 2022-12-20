//
//  RoundedCardCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/12/2022.
//

import Foundation
import UIKit

struct RoundedCardCellModel: ActionProvider {
    var model: RoundedCardViewConfig
    var action: Callback?
}

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
        selectionStyle = .none
    }
    
    func configure(with model: RoundedCardCellModel) {
        card.configureView(with: model.model)
    }
}
