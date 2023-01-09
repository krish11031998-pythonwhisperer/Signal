//
//  ProfileHeaderView.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 08/01/2023.
//

import Foundation
import UIKit
import Combine

class ProfileHeaderView: UIView {

    private lazy var imgView: UIImageView = { .standardImageView(frame: .init(origin: .zero, size: .init(squared: 96)), circleFrame: true) }()
    
    private lazy var userInfo: DualLabel = { .init(spacing: 8, alignment: .center) }()
    private var bag: Set<AnyCancellable> = .init()
    private var cancellable: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stack = UIStackView.VStack(subViews: [imgView, userInfo],
                                       spacing: 12,
                                       alignment: .center)
        addSubview(stack)
        setFittingConstraints(childView: stack, insets: .init(top: 0, left: 0, bottom: 15, right: 0))
    }

    private func configure() {
        guard let user = AppStorage.shared.user else { return }
        imgView.clipsToBounds = true
        cancellable = UIImage.loadImage(url: user.img, at: imgView, path: \.image)
        userInfo.configure(title: user.name.body1Bold(),
                            subtitle: user.userName.body2Medium())
    }
    
    deinit {
        print("(DEBUG) headerView Deinit!")
        cancellable?.cancel()
    }
}
