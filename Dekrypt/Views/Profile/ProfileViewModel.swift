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
    
    let cardAppearance: RoundedCardAppearance = .init(backgroundColor: .surfaceBackground,
                                                      cornerRadius: 16,
                                                      insets: .init(vertical: 10, horizontal: 15),
                                                      iterSpacing: 8,
                                                      lineSpacing: 8,
                                                      height: .constant(48))
    private let addTicker: PassthroughSubject<Void, Never>
    private var bag: Set<AnyCancellable> = .init()
    private let signOutUser: PassthroughSubject<Void, Never> = .init()
    var user: UserModel? { AppStorage.shared.user }
    init() {
        self.addTicker = .init()
    }
    
    struct Input {
        let ticker: CurrentValueSubject<String?, Never>
    }
    
    struct Output {
        let sections: AnyPublisher<[TableSection], Never>
        let showTickersPage: VoidPublisher
        let updateWatchList: AnyPublisher<TableSection, Error>
        let signOutUser: AnyPublisher<(), Error>
    }
    
    func transform(input: Input) -> Output {
        
        let sections = Just([self.watchList(), self.signOut()].compactMap { $0 }).eraseToAnyPublisher()
        
        let showTickerPage = addTicker.eraseToAnyPublisher()
        
        let updateWatchlist: AnyPublisher<TableSection, Error> = input.ticker
            .compactMap { $0 }
            .withLatestFrom(AppStorage.shared.userPublisher)
            .flatMap { (ticker, user) in UserService.shared.updateWatchlist(uid: user.uid, asset: ticker) }
            .compactMap { [weak self] in
                guard let newUser = $0.data else { return nil }
                AppStorage.shared.user = newUser
                return self?.watchList()
            }
            .eraseToAnyPublisher()

        
        let signOutUser = signOutUser
            .flatMap { _ in FirebaseAuthService.shared.signOutUser() }
            .eraseToAnyPublisher()
        
        return .init(sections: sections,
                     showTickersPage: showTickerPage,
                     updateWatchList: updateWatchlist,
                     signOutUser: signOutUser)
    }
    
    private func userInfo() -> TableSection {
        let emailRow = TableRow<RoundedCardCell>(.init( cardAppearance: cardAppearance,
                                                        model: .init(title: "Name".body3Regular(color: .gray),
                                                                     caption: user?.name.body3Medium())))

        return .init(rows: [emailRow], title: "Info")
    }
    
    private func watchList(newTicker: String? = nil) -> TableSection? {
        let watching = user?.watching ?? []
        return .init(rows: [TableRow<ProfileWatchListCell>(.init(ticker: watching, addTicker: addTicker))],
                     title: "Watchlist")
    }
    
    private func signOut() -> TableSection {
        let buttonModel: RoundedCardCellModel = .init(cardAppearance: cardAppearance, model: .init(title: "Sign Out".body3Medium(color: .red))){
            self.signOutUser.send(())
        }
        let signOutButton = TableRow<RoundedCardCell>(buttonModel)
        return .init(rows: [signOutButton])
    }
    
    
    private func updateUserWatchlist(ticker: String?) {
        
    }
}
