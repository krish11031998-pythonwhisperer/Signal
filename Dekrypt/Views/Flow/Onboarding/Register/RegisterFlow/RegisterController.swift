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
    
    private var viewModel: RegisterViewModel
    private var bag: Set<AnyCancellable> = .init()
    
    init(user: CurrentValueSubject<UserModel?, Never>, nextPage: PassthroughSubject<Void, Never>) {
        self.viewModel = .init(currentUser: user, nextPage: nextPage)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }

    private func setupView() {
        view.backgroundColor = .surfaceBackground

        let stack = UIStackView.VStack(subViews: [emailField.embedWithHeader(title: Constants.email),
                                                  passwordField.embedWithHeader(title: Constants.password),
                                                  confirmPasswordField.embedWithHeader(title: Constants.confirmPassword)],
                                       spacing: 12)
    
        stack.addArrangedSubview(.spacer())
        stack.addArrangedSubview(UIStackView.init(arrangedSubviews: [.spacer(), registerButton]))
         
        view.addSubview(stack)
        view.setFittingConstraints(childView: stack, insets: .zero)
        
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
        
        let registerButtonAction: AnyPublisher<RegisterModel, Never> =
        registerButton.publisher(for: .touchUpInside)
            .map { [weak self] _ in
                return .init(email: self?.emailField.text, password: self?.passwordField.text)
            }.eraseToAnyPublisher()
        
        let output = viewModel.transform(input: .init(registerUser: registerButtonAction))
        
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
                    self?.viewModel.nextPage.send(())
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
