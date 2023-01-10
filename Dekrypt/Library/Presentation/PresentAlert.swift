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
    
//    private lazy var body: UILabel = { .init() }()
//    private lazy var viewButton: UIButton = { .init() }()
    private lazy var body: AlertInfo = { .init() }()
    private let titleText: String
    private let bodyText: String
    private let buttontext: String?
    private let handle: PassthroughSubject<(), Never>?
    private var bag: Set<AnyCancellable> = .init()
    private let dismisshandle: PassthroughSubject<(), Never> = .init()
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
        bind()
    }
    
    
    private func setupNav() {
        let title = titleText.styled(font: .medium, color: .textColor, size: 25).generateLabel
        standardNavBar(leftBarButton: .init(customView: title), color: .clear, scrollColor: .clear)
        navigationController?.additionalSafeAreaInsets.top = 10
        navigationController?.navigationBar.clipsToBounds = true
    }
    
    private func setupView() {
        view.backgroundColor = .surfaceBackground
        view.addSubview(body)
        view.setFittingConstraints(childView: body, insets: .init(top: navBarHeight + 10, left: 16, bottom: .safeAreaInsets.bottom, right: 16))
        view.cornerRadius = 32
        
        body.configure(buttonTitle: buttontext?.body3Medium(color: .textColorInverse),
                       label: bodyText.body1Medium(),
                       handle: dismisshandle)
    }
    
    private func bind() {
        dismisshandle
            .sinkReceive({ [weak self] in
                self?.handle?.send($0)
                self?.dismiss(animated: true)
            })
            .store(in: &bag)
    }
    
}

class AlertInfo: UIView {
    
    private lazy var messageLabel: UILabel = { .init() }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .surfaceBackgroundInverse
        button.clippedCornerRadius = 15
        button.setHeight(height: 50)
        return button
    }()
    private lazy var stack: UIStackView = .VStack(subViews: [messageLabel, .spacer(), button], spacing: 8)
    private var buttonHandle: PassthroughSubject<(), Never>?
    private var bag: Set<AnyCancellable> = .init()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.numberOfLines = 0
        button.isHidden = true
        addSubview(stack)
        setFittingConstraints(childView: stack, insets: .zero)
        bind()
    }
    
    private func bind() {
        button.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.button.animate(.bouncy)
                self?.buttonHandle?.send(())
            }
            .store(in: &bag)
    }
    
    func configure(buttonTitle: RenderableText?, label: RenderableText?, handle: PassthroughSubject<(), Never>?) {
        label?.render(target: self.messageLabel)
        self.buttonHandle = handle
        if let buttonTitle {
            button.isHidden = false
            buttonTitle.render(target: self.button)
        }
    }
}


extension UILabel {
    func sizeToFitContent(maxWidth: CGFloat = .greatestFiniteMagnitude) {
        guard
            let validText = text,
            let validFont = font
        else { return }
        
        let size = validText.sizeThatFits(font: validFont, width: maxWidth)
        var newFrame = frame
        newFrame.size = .init(width: size.width, height: size.height + 20)
        
        frame = newFrame
    }
}


extension String {
    func sizeThatFits(font: UIFont,
                      width: CGFloat = .greatestFiniteMagnitude,
                      height: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        let string = NSString(string: self)
        let rect = string.boundingRect(with: CGSize(width: width, height: height),
                                       options: .usesLineFragmentOrigin,
                                       attributes: [.font: font],
                                       context: nil)
        return rect.size
    }
}
