//
//  ProfileViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 30/12/2022.
//

import Foundation
import UIKit
import Combine

class ProfileViewModel {
    
    let user: UserModel
    let cardAppearance: RoundedCardAppearance = .init(backgroundColor: .surfaceBackground,
                                                      cornerRadius: 16,
                                                      insets: .init(vertical: 10, horizontal: 15),
                                                      iterSpacing: 8,
                                                      lineSpacing: 8,
                                                      height: .constant(48))
    private let addTicker: PassthroughSubject<Void, Never>
    private var bag: Set<AnyCancellable> = .init()
    
    init(user: UserModel) {
        self.user = user
        self.addTicker = .init()
    }
    
    struct Output {
        let sections: AnyPublisher<[TableSection], Never>
        let showTickersPage: VoidPublisher
    }
    
    func transform() -> Output {
        let sections = Just([userInfo(), watchList()]).eraseToAnyPublisher()
        return .init(sections: sections, showTickersPage: addTicker.eraseToAnyPublisher())
    }
    
    private func userInfo() -> TableSection {
        let emailRow = TableRow<RoundedCardCell>(.init( cardAppearance: cardAppearance,
                                                        model: .init(title: "Name".body3Regular(color: .gray),
                                                                     caption: user.name.body3Medium())))

        return .init(rows: [emailRow], title: "Info")
    }
    
    private func watchList() -> TableSection {
        let tickers = user.watching.map {
            var appearance = RoundedCardAppearance.default
            appearance.insets = .init(vertical: 5, horizontal: 10)
            appearance.cornerRadius = 10
            let card = RoundedCardView(appearance: appearance)
            let cancellables = card.configureView(with: .init(title: $0.body3Medium(),
                                                              leadingView: .image(url: $0.logoURL,
                                                                                  size: .init(squared: 28),
                                                                                  cornerRadius: 14)))
            card.addShadow()
            cancellables?.forEach { bag.insert($0) }
            return card
        }
        
        let stack: UIView = .flexibleStack(subViews: tickers, width: .totalWidth - 20)
        
        let buttonLabel = "Add+".bodySmallRegular(color: .textColorInverse).generateLabel
        let button = buttonLabel.blobify(backgroundColor: .surfaceBackgroundInverse,
                                         edgeInset: .init(vertical: 5, horizontal: 7.5),
                                         cornerRadius: 12)
            .buttonify {
                self.addTicker.send(())
            }
        
        let header = "Tickers Watchlist".heading2()
                        .generateLabel
        
        let view = UIStackView.HStack(subViews: [header, .spacer(), button], spacing: 10, alignment: .center).embedInView(insets: .init(by: 10))
        
        return .init(rows: [TableRow<CustomTableCell>(.init(view: stack,
                                                            inset: .init(vertical: 5, horizontal: 10),
                                                            name: "tickersCell"))],
                     customHeader: view)
    }
    
}
