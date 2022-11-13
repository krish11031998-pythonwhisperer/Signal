//
//  TickerStoryDetailView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 13/11/2022.
//

import Foundation
import UIKit

class TickerStoryDetailView: UIViewController {
    
    @StandardImageView private var imageView
    private lazy var titleLabel: UILabel = { .init() }()
    private lazy var descriptionLabel: UILabel = { .init() }()
    private lazy var viewNews: UIView = { .init() }()
    
    private lazy var viewMoreButton: UIButton = {
        let button = UIButton()
        "View News".body1Medium().render(target: button)
        button.backgroundColor = .appBlue
        button.titleLabel?.textAlignment = .center
        button.cornerRadius = 8
        button.setHeight(height: 50, priority: .required)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    private let news: NewsModel
    @TickerSymbolView var tickers
    
    init(news: NewsModel) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupView()
        _tickers.configTickers(news: news)
    }
    
    private func setupView() {
        view.backgroundColor = .surfaceBackground
        view.clippedCornerRadius = 24
        
        titleLabel.numberOfLines = 3
        descriptionLabel.numberOfLines = 4
        
        news.title.heading2().render(target: titleLabel)
        news.text.body2Medium().render(target: descriptionLabel)
        UIImage.loadImage(url: news.imageUrl, at: imageView, path: \.image)
        
        setupMainStack()
    }
    
    private func setupNav() {
        standardNavBar(rightBarButton: .init(image: .init(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(dismissView)))
        navigationItem.leftBarButtonItem = nil
        navigationController?.additionalSafeAreaInsets = .init(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    private func setupButton() -> UIButton {
        let button = UIButton()
        "View News".body1Medium().render(target: button)
        button.backgroundColor = .appBlue
        button.titleLabel?.textAlignment = .center
        button.cornerRadius = 8
        button.setHeight(height: 50, priority: .required)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }
    
    private func setupMainStack() {
        let descriptionStack = setupDescriptionStack()
        let mainStack = [imageView, descriptionStack].embedInVStack(alignment: .center, spacing: 10)
        mainStack.setCustomSpacing(32, after: imageView)
        mainStack.setFittingConstraints(childView: imageView, leading: 0, trailing: 0, height: .totalHeight.half)

        view.addSubview(mainStack)
        view.setFittingConstraints(childView: mainStack, insets: .zero)
    }
    
    private func setupDescriptionStack() -> UIView {
        let stack = [titleLabel, descriptionLabel, tickers, .spacer(), viewMoreButton, .spacer(height: 24)].embedInVStack(alignment: .leading, spacing: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(vertical: 0, horizontal: 20)
        stack.setFittingConstraints(childView: viewMoreButton, leading: 20, trailing: 20)
        return stack
    }
    
    @objc
    private func dismissView() {
        dismiss(animated: true)
    }
}

