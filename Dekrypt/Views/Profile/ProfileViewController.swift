//
//  ProfileViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 30/12/2022.
//

import Foundation
import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModel
    private lazy var tableView: UITableView = { .standardTableView() }()
    private var ticker: CurrentValueSubject<String?, Never> = .init(nil)
    private var bag: Set<AnyCancellable> = .init()
    private let closeButton: PassthroughSubject<(), Never> = .init()
    var user: UserModel? { AppStorage.shared.user }
    init() {
        self.viewModel = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        standardNavBar()
        bind()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: .zero)
        profileHeaderView()
    }
    
    private func profileHeaderView() {
        let imgView: UIImageView = .standardImageView(frame: CGSize(squared: 96).frame, circleFrame: true)
        imgView.image = .Catalogue.profileImage.image.resized(size: .init(squared: 96))
        imgView.clipsToBounds = true
        let dualLabel = DualLabel(spacing: 8, alignment: .center)
        dualLabel.configure(title: user?.name.body1Bold(),
                            subtitle: user?.userName.body2Medium())
        
        let stack = UIStackView.VStack(subViews: [imgView, dualLabel],
                                       spacing: 12,
                                       alignment: .center)
        tableView.animateHeaderView = stack
    }
    
    private func bind() {
        let output = viewModel.transform(input: .init(ticker: ticker))
        
        output.sections
            .sink { [weak self] sections in
                guard let self else { return }
                self.tableView.reloadData(.init(sections: sections))
            }
            .store(in: &bag)
        
        output.showTickersPage
            .sink { [weak self] _ in
                guard let self else { return }
                let target = ProfileSearchViewController(selectedTicker: self.ticker).withNavigationController()
                self.presentView(style: .sheet(size: .totalScreenSize), target: target, onDimissal: nil)
            }
            .store(in: &bag)
        
        output.signOutUser
            .sink {
                if let err = $0.err {
                    print("(ERROR) err:", err.localizedDescription)
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true)
            }
            .store(in: &bag)
        
        output.updateWatchList
            .receive(on: DispatchQueue.main)
            .sink {
                if let err = $0.err {
                    print("(ERROR) err: ", err.localizedDescription)
                }
            } receiveValue: { [weak self] section in
                guard let self else { return }
                self.tableView.reloadSection(section, at: 0)
            }
            .store(in: &bag)

    }
}
