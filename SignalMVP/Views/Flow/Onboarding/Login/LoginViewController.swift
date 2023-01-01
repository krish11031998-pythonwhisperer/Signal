//
//  LoginViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/12/2022.
//

import Foundation
import UIKit
import Combine

class LoginController: UIViewController {
    
    private lazy var emailField: TextField = { .init(placeHolder: Constants.email) }()
    private lazy var passwordField: TextField = { .init(placeHolder: Constants.password, type: .password) }()
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        Constants.loginButton.body2Medium(color: .surfaceBackground).render(target: button)
        button.backgroundColor = .surfaceBackgroundInverse
        button.setFrame(.init(width: 100, height: 45))
        button.clippedCornerRadius = button.frame.size.smallDim.half
        return button
    }()
    private var bag: Set<AnyCancellable> = .init()
    private let viewModel: LoginViewModel = { .init() }()
    private let loginModel: PassthroughSubject<UserLoginModel, Never> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupView()
        bind()
    }
    
    
    private func setupNavbar() {
        standardNavBar(title: "Login".heading3())
    }
    
    private func setupView() {
        view.backgroundColor = .surfaceBackground
        
        let stack = UIStackView.VStack(subViews: [textFieldWithLabel(title: Constants.email, textField: emailField),
                                                  textFieldWithLabel(title: Constants.password, textField: passwordField)],
                                       spacing: 12)
    
        stack.addArrangedSubview(.spacer())
        stack.addArrangedSubview(UIStackView.init(arrangedSubviews: [.spacer(), loginButton]))
        
        view.addSubview(stack)
        view.setFittingConstraints(childView: stack, insets: .init(top: .safeAreaInsets.top + navBarHeight + 32, left: 10, bottom: .safeAreaInsets.bottom, right: 10))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    private func textFieldWithLabel(title: String, textField: UITextField) -> UIView {
        let stack = UIStackView.VStack(spacing: 8)
        let title = title.body3Regular().generateLabel
        [title, textField].addToView(stack)
        textField.setHeight(height: 50)
        return stack
    }
    
    private func bind() {
        loginButton.publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                guard let self,
                      let username = self.emailField.text,
                      let password = self.passwordField.text
                else { return }
                self.loginModel.send(.init(username: username, password: password))
            })
            .store(in: &bag)

        let output = viewModel.transform(input: .init(userLogin: loginModel.eraseToAnyPublisher()))
        
        output.navigation
            .receive(on: RunLoop.main)
            .sink {
                print("(ERROR) err from nav!: ", $0.err?.localizedDescription)
            } receiveValue: { routes in
                switch routes {
                case .nextPage:
                    self.dismiss(animated: true)
                }
            }
            .store(in: &bag)
        
        output.errMsg
            .sink {
                print("(ERROR) ErrMsg: ", $0.errMsg)
            }
            .store(in: &bag)

    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Constants

extension LoginController {
    enum Constants {
        static var email = "Email"
        static var password = "Password"
        static var loginButton = "Login"
    }
}

