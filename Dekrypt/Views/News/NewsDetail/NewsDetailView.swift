//
//  TickerStoryDetailView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 13/11/2022.
//

import Foundation
import UIKit
import Combine

class NewsDetailView: UIViewController {
    
    private var imageView: UIImageView = { .standardImageView() }()
    private lazy var titleLabel: UILabel = { .init() }()
    private lazy var authorLabel: UILabel = { .init() }()
    private lazy var descriptionLabel: UILabel = { .init() }()
    private lazy var viewNews: UIView = { .init() }()
    private lazy var scrollView: ScrollView = { .init(ignoreSafeArea: false) }()
    private var bag: Set<AnyCancellable> = .init()
    private lazy var viewMoreButton: UIButton = {
        let button = UIButton()
        "View News".body1Medium().render(target: button)
        button.backgroundColor = .appBlue
        button.titleLabel?.textAlignment = .center
        button.cornerRadius = 8
        button.setHeight(height: 50, priority: .required)
        return button
    }()
    
    private let news: NewsModel
    private lazy var tickersView: TickerSymbolView = { .init() }()
    
    init(news: NewsModel) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tickersView.configTickers(news: news)
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBarIfRequired()
        setupNav()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBarIfRequired()
        //setupTransparentNavBar(color: .surfaceBackground, scrollColor: .surfaceBackground)
    }
    
    private func setupView() {
        view.backgroundColor = .surfaceBackground
        view.clippedCornerRadius = 24
        
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
        news.title.heading2().render(target: titleLabel)
        news.text.body2Medium().render(target: descriptionLabel)
        news.sourceName.body3Regular(color: .gray).render(target: authorLabel)
        UIImage.loadImage(url: news.imageUrl, at: imageView, path: \.image)
        
        setupMainStack()
    }
    
    private func setupNav() {
        if navigationController?.modalPresentationStyle == .custom {
            standardNavBar(rightBarButton: Self.closeButton(self),
                           color: .clear)
            navigationItem.leftBarButtonItem = nil
        } else {
            standardNavBar()
        }
    }
    
    private func hideTabBarIfRequired() {
        guard navigationController?.modalPresentationStyle != .custom else { return }
        navigationController?.tabBarController?.tabBar.hide = true
    }
    
    private func showTabBarIfRequired() {
        guard navigationController?.modalPresentationStyle != .custom else { return }
        navigationController?.tabBarController?.tabBar.hide = false
    }
    
    private func setupMainStack() {
        scrollView.addArrangedView(view: titleLabel.embedInView(insets: .init(top: 10, left: 0, bottom: 0, right: 0)))
        scrollView.addArrangedView(view: authorLabel, additionalSpacing: 24)
        scrollView.addArrangedView(view: imageView, additionalSpacing: 24)
        scrollView.addArrangedView(view: descriptionLabel, additionalSpacing: 16)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addArrangedView(view: UIStackView.HStack(subViews: [tickersView, .spacer()], spacing: 0, alignment: .center))
        scrollView.addArrangedView(view: .spacer(height: 75))
        view.addSubview(scrollView)
        view.setFittingConstraints(childView: scrollView, insets: .init(top: 0,
                                                                        left: 16,
                                                                        bottom: 0,
                                                                        right: 16))

        imageView.setHeight(height: .totalHeight * 0.35, priority: .required)
        imageView.clippedCornerRadius = 16
        view.addSubview(viewMoreButton)
        view.setFittingConstraints(childView: viewMoreButton, leading: 20, trailing: 20, bottom: .safeAreaInsets.bottom)
    }
    
    private func setupDescriptionStack() -> UIView {
        let stack = [titleLabel, descriptionLabel, tickersView, .spacer(height: 24)].embedInVStack(alignment: .leading, spacing: 10)
        stack.setCustomSpacing(16, after: descriptionLabel)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(vertical: 0, horizontal: 20)
        return stack
    }
    
    @objc
    private func dismissView() {
        dismiss(animated: true)
    }
    
    private func setupObservers() {
        viewMoreButton.publisher(for: .touchUpInside)
            .sink(receiveValue: showWebpage(_:))
            .store(in: &bag)
    }
    
    private func showWebpage(_ publisher: UIControl.EventPublisher.Output) {
        let webPage = WebPageView(url: news.newsUrl, title: news.title).withNavigationController()
        presentView(style: .sheet(), target: webPage, onDimissal: nil)
    }
}

