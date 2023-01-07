//
//  HomeFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit
import Combine

class HomeFeed: UIViewController {
	
//MARK: - Properties
    private lazy var tableView: UITableView = { .standardTableView() }()

    private lazy var viewModel: HomeViewModel = { .init() }()
    
    private var bag: Set<AnyCancellable> = .init()
	
//MARK: - Overriden Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
        startLoadingAnimation()
        bind()
	}
	
//MARK: - ProtectedMethods
	
    private func setupNavbar() {
        setupTransparentNavBar(color: .surfaceBackground, scrollColor: .surfaceBackground)
        let customView = (UIImage.Catalogue.user.image.resized(size: .init(squared: 20)).withTintColor(.surfaceBackground) + "Profile".styled(font: .medium , color: .textColorInverse, size: 12)).generateLabel.blobify(backgroundColor: .surfaceBackgroundInverse, edgeInset: .init(vertical: 5, horizontal: 10), borderColor: .clear, borderWidth: 0, cornerRadius: 16)
        customView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProfile)))
        navigationItem.rightBarButtonItem = .init(customView: customView)
    }
    
    private func setupLoginBar() {
        setupTransparentNavBar(color: .surfaceBackground, scrollColor: .surfaceBackground)
        let customView = "Login".styled(font: .medium, color: .textColorInverse, size: 12).generateLabel.blobify(backgroundColor: .surfaceBackgroundInverse, edgeInset: .init(vertical: 5, horizontal: 10), borderColor: .clear, borderWidth: 0, cornerRadius: 10)
        customView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showLogin)))
        navigationItem.rightBarButtonItem = .init(customView: customView)
    }
    
	private func setupViews() {
		view.addSubview(tableView)
		view.setFittingConstraints(childView: tableView, insets: .zero)
		view.backgroundColor = .surfaceBackground
		tableView.backgroundColor = .clear
	}
    
    private func bind() {
        let output = viewModel.transform()
        
        output.sections
            .map { TableViewDataSource(sections: $0) }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.endLoadingAnimation()
            })
            .sink {
                if let err = $0.err?.localizedDescription {
                    print("(ERROR) err: ", err)
                }
            } receiveValue: { [weak self] in
                guard let self else { return }
                self.tableView.reloadData($0)
            }
            .store(in: &bag)

        output.navigation
            .sink { [weak self] in
                guard let self else { return }
                switch $0 {
                case .toTickerStory(_, let frame):
                    self.presentView(style: .circlar(frame: frame), target: $0.destination, onDimissal: nil)
                default:
                    self.pushTo(target: $0.destination)
                }
            }
            .store(in: &bag)
        
        output
            .user
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {
                if let err = $0.err?.localizedDescription {
                    print("(ERROR) err: ", err)
                }
            }, receiveValue: { [weak self] user in
                guard let self else { return }
                AppStorage.shared.user = user
                if user != nil {
                    self.setupNavbar()
                } else {
                    self.setupLoginBar()
                }
            })
            .store(in: &bag)
        
        output.storyViewUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.tableView.reloadSection($0, at: 0)
            }
            .store(in: &bag)
    }
    
    @objc
    private func showProfile() {
        presentView(style: .sheet(size: .totalScreenSize),
                    target: ProfileViewController().withNavigationController(),
                    onDimissal: nil)
    }
	
    
    @objc
    private func showLogin() {
        let onboarding = OnboardingController().withNavigationController()
        presentView(style: .sheet(), target: onboarding) {
            print("(DEBUG) closed Onboarding!")
        }
    }
}
