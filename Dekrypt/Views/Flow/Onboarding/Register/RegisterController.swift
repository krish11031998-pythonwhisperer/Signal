//
//  LoginController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/12/2022.
//

import Foundation
import UIKit
import Combine

class RegisterController: UIViewController {
    
    private lazy var usernameField: TextField = { .init(placeHolder: Constants.username) }()
    private lazy var emailField: TextField = { .init(placeHolder: Constants.email) }()
    private lazy var passwordField: TextField = { .init(placeHolder: Constants.password, type: .password) }()
    private lazy var confirmPasswordField: TextField = { .init(placeHolder: Constants.confirmPassword, type: .password) }()
    private let registerModel: PassthroughSubject<RegisterModel, Never> = .init()
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        Constants.registerButton.body2Medium(color: .surfaceBackground).render(target: button)
        button.backgroundColor = .surfaceBackgroundInverse
        button.setFrame(.init(width: 100, height: 45))
        button.clippedCornerRadius = button.frame.size.smallDim.half
        return button
    }()
    
    private var viewModel: RegisterViewModel = .init()
    private var bag: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupView()
        bind()
    }
    
    private func setupNavbar() {
        standardNavBar(title: "Register".heading3())
    }
    
    private func setupView() {
        view.backgroundColor = .surfaceBackground
        
        let stack = UIStackView.VStack(subViews: [textFieldWithLabel(title: Constants.username, textField: usernameField),
                                                  textFieldWithLabel(title: Constants.email, textField: emailField),
                                                  textFieldWithLabel(title: Constants.password, textField: passwordField),
                                                  textFieldWithLabel(title: Constants.confirmPassword, textField: confirmPasswordField)],
                                       spacing: 12)
    
        stack.addArrangedSubview(.spacer())
        stack.addArrangedSubview(UIStackView.init(arrangedSubviews: [.spacer(), registerButton]))
        
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
        
        let registerButtonAction =  registerButton.publisher(for: .touchUpInside).map { [weak self] _ in
            self?.registerModel.send(.init(username: self?.usernameField.text, email: self?.emailField.text, password: self?.passwordField.text))
            return ()
        }.eraseToAnyPublisher()
        
        let output = viewModel.transform(input: .init(registerModel: registerModel.eraseToAnyPublisher(),
                                                      registerUser: registerButtonAction))
        
        output.navigation
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] in
                if let err = $0.err?.localizedDescription{
                    print("(ERROR) err from nav!: ", err)
                    self?.showAlert(title: "Error", body: err)
                }
            }, receiveValue: { [weak self] in
                switch $0 {
                case .nextPage:
                    print("(DEBUG) nextpage!")
                    self?.dismiss(animated: true)
                case .errorMessage(let err):
                    print("(ERROR) err: ", err)
                    self?.showAlert(title: "Error", body: err)
                default:
                    break
                }
            })
            .store(in: &bag)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Constants

extension RegisterController {
    enum Constants {
        static var username = "Username"
        static var email = "Email"
        static var password = "Password"
        static var confirmPassword = "Confirm Password"
        static var registerButton = "Register"
    }
}
