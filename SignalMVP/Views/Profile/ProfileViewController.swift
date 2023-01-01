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
    private var bag: Set<AnyCancellable> = .init()
    private let closeButton: PassthroughSubject<(), Never> = .init()
    
    init(user: UserModel) {
        self.viewModel = .init(user: user)
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
        //UIImage.loadImage(url: viewModel.user.img, at: imgView, path: \.image).store(in: &bag)
        imgView.clipsToBounds = true
        let dualLabel = DualLabel(spacing: 8, alignment: .center)
        dualLabel.configure(title: viewModel.user.name.body1Bold(),
                            subtitle: viewModel.user.userName.body2Medium())
        
        let stack = UIStackView.VStack(subViews: [imgView, dualLabel],
                                       spacing: 12,
                                       alignment: .center)
        tableView.animateHeaderView = stack
    }
    
    private func bind() {
        let output = viewModel.transform()
        
        output.sections
            .sink { [weak self] sections in
                guard let self else { return }
                self.tableView.reloadData(.init(sections: sections))
            }
            .store(in: &bag)
        
        output.showTickersPage
            .sink { [weak self] _ in
                guard let self else { return }
//                self.showAlert(title: "Ticker Search",
//                               body: "You can serach you tickers you would like to add! You can serach you tickers you would like to add! You can serach you tickers you would like to add! You can serach you tickers you would like to add!",
//                               buttonText: "Close",
//                               handle: self.closeButton)
                let target = ProfileSearchViewController().withNavigationController()
                self.presentView(style: .sheet(size: .totalScreenSize), target: target, onDimissal: nil)
            }
            .store(in: &bag)
    }
}
