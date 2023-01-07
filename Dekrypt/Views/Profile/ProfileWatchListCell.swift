//
//  ProfileWatchListCell.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 07/01/2023.
//

import Foundation
import UIKit
import Combine

struct ProfileWatchListCellModel {
    let ticker: [String]
    let addTicker: PassthroughSubject<Void,Never>
}

class ProfileWatchListCell: ConfigurableCell {
    private lazy var button: UIButton = {
        let button = UIButton()
        "Add +".bodySmallRegular(color: .textColorInverse).render(target: button)
        button.backgroundColor = .surfaceBackgroundInverse
        button.clippedCornerRadius = 15
        return button
    }()
    private lazy var mainStack: UIStackView = { .VStack(subViews: [button], spacing: 8, alignment: .leading) }()
    
    private var bag: Set<AnyCancellable> = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        button.setFrame(width: 60, height: 30)
        contentView.addSubview(mainStack)
        contentView.setFittingConstraints(childView: mainStack, insets: .init(by: 10))
        selectionStyle = .none
        contentView.backgroundColor = .surfaceBackground
    }
    
    private func buildTickerCard(_ ticker: String) -> UIView {
        var appearance = RoundedCardAppearance.default
        appearance.insets = .init(vertical: 5, horizontal: 7.5)
        appearance.cornerRadius = 20
        let card = RoundedCardView(appearance: appearance)
        let cancellables = card.configureView(with: .init(title: ticker.body3Medium(),
                                                          leadingView: .image(url: ticker.logoURL,
                                                                              size: .init(squared: 30),
                                                                              cornerRadius: 15)))
        card.addShadow()
        cancellables?.forEach { bag.insert($0) }
        return card
    }
    
    
    func configure(with model: ProfileWatchListCellModel) {
        if !bag.isEmpty {
            bag.forEach { $0.cancel() }
        }
        
        button.publisher(for: .touchUpInside)
            .sink { _ in model.addTicker.send(()) }
            .store(in: &bag)
        
        guard !model.ticker.isEmpty else { return }
        let tickers = model.ticker.map(buildTickerCard(_:))

        mainStack.removeChildViews()
    
        let rows = tickers.sizeFittingStack(for: .totalWidth - 20, with: 8)
        rows.forEach { row in
            let rowStack = UIView.HStack(subViews: row + [.spacer()], spacing: 8)
            mainStack.addArrangedSubview(rowStack)
        }

        mainStack.addArrangedSubview(button)
    }
}
