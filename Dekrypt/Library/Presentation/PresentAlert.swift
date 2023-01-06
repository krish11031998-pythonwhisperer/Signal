//
//  PresentAlert.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 31/12/2022.
//

import Foundation
import UIKit
import Combine

class AlertController: UIViewController {
    
    private lazy var body: UILabel = { .init() }()
    private lazy var viewButton: UIButton = { .init() }()
    private let titleText: String
    private let bodyText: String
    private let buttontext: String?
    private let handle: PassthroughSubject<(), Never>?
    private var bag: Set<AnyCancellable> = .init()
    
    init(title: String, bodyText: String,
         buttonText: String? = nil,
         handle: PassthroughSubject<(), Never>? = nil) {
        self.titleText = title
        self.bodyText = bodyText
        self.buttontext = buttonText
        self.handle = handle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupView()
        setupButton()
    }
    
    
    private func setupNav() {
        let title = titleText.styled(font: .medium, color: .textColor, size: 25).generateLabel
        standardNavBar(leftBarButton: .init(customView: title), color: .clear, scrollColor: .clear)
        navigationController?.additionalSafeAreaInsets.top = 10
        navigationController?.navigationBar.clipsToBounds = true
    }
    
    private func setupView() {
        view.backgroundColor = .surfaceBackground
        body.numberOfLines = 0
        
        bodyText.body2Medium().render(target: body)
        body.sizeToFit()

        let stack: UIStackView = .VStack(subViews: [body, .spacer(), viewButton], spacing: 10)
        view.addSubview(stack)
        view.setFittingConstraints(childView: stack, insets: .init(top: navBarHeight + 10, left: 16, bottom: .safeAreaInsets.bottom, right: 16))
        view.cornerRadius = 32
    }
    
    private func setupButton() {
        viewButton.setHeight(height: 50)
        viewButton.backgroundColor = .surfaceBackgroundInverse
        viewButton.clippedCornerRadius = 12
        
        guard let buttontext, let handle else {
            viewButton.isHidden = true
            return
        }
        buttontext.body2Medium(color: .textColorInverse).render(target: viewButton)
        
        viewButton.publisher(for: \.isTouchInside)
            .removeDuplicates()
            .map { _ in ()}
            .handleEvents(receiveOutput: { [weak self] in
                guard let self else { return }
                self.viewButton.animate(.bouncy)
            })
            .sink {
                handle.send($0)
            }
            .store(in: &bag)
    }
    
    
}


