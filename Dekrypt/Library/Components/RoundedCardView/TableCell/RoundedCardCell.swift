//
//  RoundedCardCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/12/2022.
//

import Foundation
import UIKit
import Combine

struct RoundedCardCellModel: ActionProvider {
    let cardAppearance: RoundedCardAppearance?
    let model: RoundedCardViewConfig
    let action: Callback?
    
    init(cardAppearance: RoundedCardAppearance? = nil, model: RoundedCardViewConfig, action: Callback? = nil) {
        self.cardAppearance = cardAppearance
        self.model = model
        self.action = action
    }
}

class RoundedCardCell: ConfigurableCell {
    
    private lazy var card: RoundedCardView = { .init() }()
    private var bag: Set<AnyCancellable> = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        card.addShadow()
        contentView.addSubview(card)
        contentView.setFittingConstraints(childView: card, insets: .init(vertical: 5, horizontal: 10))
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func configure(with model: RoundedCardCellModel) {
        if let appearance = model.cardAppearance {
            card.appearance = appearance
        }
        let cancellables = card.configureView(with: model.model)
        cancellables?.compactMap { $0 }.forEach { bag.insert($0) }
    }
    
    override func prepareForReuse() {
        bag.forEach { $0.cancel() }
    }
}
