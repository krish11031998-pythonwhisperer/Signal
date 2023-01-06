//
//  LoginViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/12/2022.
//

import Foundation
import UIKit
import Combine
class OnboardingController: UIViewController {

    private lazy var loginButton: UIButton = { .init() }()
    private lazy var registerButton: UIButton = { .init() }()
    private var bag: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .surfaceBackground
        showOnboardingAction()
        bind()
        standardNavBar(leftBarButton: Self.closeButton(self))
    }
    
    private func headerView() -> UIView {
        let view: UIStackView = .VStack(spacing: 8, alignment: .center)
        
        let backgroundHolder = UIView()
        backgroundHolder.setFrame(Constants.imageViewSize)
        backgroundHolder.cornerRadius = Constants.imageViewSize.smallDim.half
        backgroundHolder.addShadow()
        
        let imageView = UIImageView.standardImageView(frame: Constants.imageViewSize.frame,
                                                      dimmingForeground: false,
                                                      circleFrame: true)
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "AppIcon")?.resized(size: Constants.imageViewSize.half)
        imageView.contentMode = .center
        
        backgroundHolder.addSubview(imageView)
        backgroundHolder.setFittingConstraints(childView: imageView, insets: .zero)
        let headerView = "Dekrypt".heading1().generateLabel
        
        [backgroundHolder, headerView].addToView(view)
        return view
    }
    
    private func showOnboardingAction() {
        
        let headerView = headerView()
        let stack = UIStackView.VStack(spacing: 10, alignment: .center)
        [headerView, .spacer(height: 100), loginButton, registerButton].addToView(stack)
        
        loginButton.backgroundColor = .surfaceBackgroundInverse
        loginButton.clippedCornerRadius = 12
        Constants.loginButtonTitle.body1Regular(color: .textColorInverse).render(target: loginButton)
        
        registerButton.backgroundColor = .surfaceBackgroundInverse
        registerButton.clippedCornerRadius = 12
        Constants.registerButtonTitle.body1Regular(color: .textColorInverse).render(target: registerButton)
        
        let infoLabel = Constants.info.body2Medium().generateLabel
        infoLabel.textAlignment = .center
        stack.insertArrangedSubview(infoLabel, at: 1)
        
        stack.setFittingConstraints(childView: loginButton, leading: 10, trailing: 10, height: 50, centerX: 0)
        stack.setFittingConstraints(childView: registerButton, leading: 10, trailing: 10, height: 50, centerX: 0)
        
        
        view.addSubview(stack)
        view.setFittingConstraints(childView: stack, centerX: 0, centerY: 0)
    }
    
    private func bind() {
        loginButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                self.loginButton.animate(.bouncy) {
                    self.routeTo(destination: .login)
                }
            }
            .store(in: &bag)
        
        registerButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                self.registerButton.animate(.bouncy) {
                    self.routeTo(destination: .register)
                }
            }
            .store(in: &bag)
    }
    
    private func routeTo(destination: Destination) {
        switch destination {
        case .login:
            self.navigationController?.pushViewController(LoginController(), animated: true)
        case .register:
            self.navigationController?.pushViewController(RegisterController(), animated: true)
        }
    }
    
    
}

extension OnboardingController {
    enum Constants {
        static var loginButtonTitle: String = "Login"
        static var registerButtonTitle: String = "Register"
        static var info: String = "A One Stop Platform for all your cryptocurrency news"
        static var imageViewSize: CGSize = .init(squared: CGSize.totalScreenSize.smallDim.half)
    }
    
    enum Destination {
        case login , register
    }
}
