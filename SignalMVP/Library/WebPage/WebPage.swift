//
//  WebPage.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 13/11/2022.
//

import Foundation
import UIKit
import WebKit

//MARK: - WenPageView
class WebPageView: UIViewController {
    
    private let urlStr: String
    private let webPageTitle: String
    private var webPage: WKWebView!

    private lazy var bottomNavBar: UIView = {
        let icons: [UIImage.Catalogue] = [.home, .chevronLeft, .chevronRight, .share]
        let iconsStack = icons.compactMap { icon in
            let img = icon.image.resized(size: .init(squared: 24)).withTintColor(.surfaceBackgroundInverse, renderingMode: .alwaysOriginal)
            let view = img.imageView()
            return view.buttonify {
                self.navigateWebPage(button: icon)
            }
        }.embedInHStack()
        iconsStack.distribution = .equalCentering
        let container = iconsStack.embedInView(insets: .init(top: 10, left: 20, bottom: .safeAreaInsets.bottom, right: 20))
        container.backgroundColor = .surfaceBackground
        return container
    }()
    
    init(url: String, title: String) {
        self.urlStr = url
        self.webPageTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupView()
        loadWebPage()
    }
    
    private func setupView() {
        webPage = .init()
        webPage.navigationDelegate = self
        webPage.allowsLinkPreview = true
        view.addSubview(webPage)
        view.setFittingConstraints(childView: webPage, insets: .init(top: 0, left: 0, bottom: bottomNavBar.compressedSize.height, right: 0))
        
        
        view.addSubview(bottomNavBar)
        view.setFittingConstraints(childView: bottomNavBar, leading: 0, trailing: 0, bottom: 0)
        
    }
    
    private func setupNavbar() {
        let titleInfo = [webPageTitle.body3Medium().generateLabel, urlStr.bodySmallRegular(color: .gray).generateLabel].embedInVStack(alignment: .leading, spacing: 3)
        standardNavBar(leftBarButton: .init(customView: titleInfo), rightBarButton: Self.closeButton(self), color: .surfaceBackground, scrollColor: .surfaceBackground)
    }
    
    private func loadWebPage() {
        guard let url = URL(string: urlStr) else { return }
        //DispatchQueue.main.async {
            self.webPage.load(.init(url: url))
        //}
    }
    
    private func navigateWebPage(button: UIImage.Catalogue) {
        switch button {
        case .home:
            guard let first = webPage.backForwardList.backList.first else { return }
            webPage.go(to: first)
        case .chevronLeft:
            webPage.goBack()
        case .chevronRight:
            webPage.goForward()
        case .share:
            print("(DEBUG) clicked on Shared!")
        default:
            break
        }
    }
}


//MARK: - WKNavigationDelegate
extension WebPageView: WKNavigationDelegate {
    
    
}
