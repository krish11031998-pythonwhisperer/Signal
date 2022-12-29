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
    var model: RoundedCardViewConfig
    var action: Callback?
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
        contentView.addSubview(card)
        contentView.setFittingConstraints(childView: card, insets: .init(vertical: 5, horizontal: 5))
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func configure(with model: RoundedCardCellModel) {
        let cancellables = card.configureView(with: model.model)
        cancellables?.compactMap { $0 }.forEach { bag.insert($0) }
    }
    
    override func prepareForReuse() {
        bag.forEach { $0.cancel() }
    }
}
