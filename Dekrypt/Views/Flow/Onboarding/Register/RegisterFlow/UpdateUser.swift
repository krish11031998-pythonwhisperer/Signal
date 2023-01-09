//
//  UpdateUser.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 08/01/2023.
//

import Foundation
import UIKit
import Combine


class RegisterUpdateUser: UIViewController {
    
    private lazy var profileImage: UIImageView = { .standardImageView(frame: .init(origin: .zero, size: .init(squared: 96)), circleFrame: true) }()
    
    private lazy var profileImageButton: UIView = {
       let view = UIView()
        view.addSubview(profileImage)
        view.setFittingConstraints(childView: profileImage, insets: .zero)
        let editIcon = UIImage.Catalogue.pencil.image.resized(withAspect: .init(squared: 8)).imageView(size: .init(squared: 20), cornerRadius: 10)
        editIcon.contentMode = .center
        editIcon.backgroundColor = .appWhite
        view.isUserInteractionEnabled = true
        view.addSubview(editIcon)
        view.setFittingConstraints(childView: editIcon, trailing: 0, bottom: 0, width: 30, height: 30)
        return view
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        Constants.update.body2Medium(color: .surfaceBackground).render(target: button)
        button.backgroundColor = .surfaceBackgroundInverse
        button.setFrame(.init(width: 100, height: 45))
        button.clippedCornerRadius = button.frame.size.smallDim.half
        return button
    }()

    private var bag: Set<AnyCancellable> = .init()
    private lazy var usernameField: TextField = { .init(placeHolder: Constants.username) }()
    private lazy var nameField: TextField = { .init(placeHolder: Constants.name) }()
    
    private let currentUser: CurrentValueSubject<UserModel?, Never>
    private let nextPage: PassthroughSubject<Void, Never>
    
    init(user: CurrentValueSubject<UserModel?, Never>, nextPage: PassthroughSubject<Void, Never>) {
        self.currentUser = user
        self.nextPage = nextPage
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
        
        let fields = UIStackView.VStack(subViews: [nameField.embedWithHeader(title: Constants.name), usernameField.embedWithHeader(title: Constants.username)], spacing: 8)
        let buttonStack = UIStackView.HStack(subViews: [.spacer(), updateButton], spacing: 0)
        let mainStack = UIStackView.VStack(subViews: [profileImageButton, fields, .spacer()], spacing: 10)
        
        mainStack.addArrangedSubview(buttonStack)
        mainStack.alignment = .center

        mainStack.setFittingConstraints(childView: fields, leading: 0, trailing: 0)
        mainStack.setFittingConstraints(childView: buttonStack, leading: 0, trailing: 0)
        
        view.addSubview(mainStack)
        view.setFittingConstraints(childView: mainStack, insets: .zero)
  
        profileImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    
    @objc
    private func handleTap() {
        print("(DEBUG) clicked on editImage")
        profileImage.animate(.bouncy) {
            let imagePickerVC = UIImagePickerController()
            imagePickerVC.sourceType = .photoLibrary
            imagePickerVC.delegate = self
            imagePickerVC.allowsEditing = true
            self.present(imagePickerVC, animated: true)
        }
    }
    
    private func bind() {
        updateButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let self else { return }
            self.nextPage.send(())
        }
        .store(in: &bag)
    }
}

//MARK: - Constants
extension RegisterUpdateUser { 
    enum Constants {
        static var username = "Username"
        static var name = "Name"
        static var update = "Update"
    }
}

//MARK: - UIPickerImageView
extension RegisterUpdateUser: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let img = (info[.editedImage] ?? info[.originalImage]) as? UIImage else { return }
        self.profileImage.image = img
        self.profileImage.clipsToBounds = true
        picker.dismiss(animated: true)
    }
}
