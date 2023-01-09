//
//  RegisterViewController.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 08/01/2023.
//

import Foundation
import UIKit
import Combine

class RegisterViewController: UIViewController {
    
    private let user: CurrentValueSubject<UserModel?, Never> = .init(nil)
    private let nextPage: PassthroughSubject<Void, Never> = .init()
    private var bag: Set<AnyCancellable> = .init()
    private lazy var pageController: UIPageViewController = { .init(transitionStyle: .scroll, navigationOrientation: .horizontal) }()
    private let pages: [UIViewController]
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pages = [
            RegisterController(user: user, nextPage: nextPage),
            RegisterUpdateUser(user: user, nextPage: nextPage)
        ]
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        bind()
        setupNavbar()
    }
    
    private func setupPages() {
        view.backgroundColor = .surfaceBackground
        addChild(pageController)
        pageController.didMove(toParent: self)
        view.addSubview(pageController.view)
        view.setFittingConstraints(childView: pageController.view, insets: .init(top: .safeAreaInsets.top + navBarHeight, left: 10, bottom: .safeAreaInsets.bottom, right: 10))
        pageController.setViewControllers([pages.first].compactMap { $0 }, direction: .forward, animated: true)
        pageController.delegate = self
        pageController.dataSource = self
        pageController.disableSwipeGesture()
    }
    
    private func setupNavbar() {
        standardNavBar(title: "Register".heading3())
    }
    
    private func bind() {
        nextPage
            .sink { [weak self] _ in
                guard let self else { return }
                print("(DEBUG) next page in the pagesController")
                if let _ = self.pageController.goToNextPage() {
                    
                } else {
                    self.dismiss(animated: true)
                }
            }
            .store(in: &bag)
        
    }
}

extension RegisterViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(of: viewController) else { return nil }
        if idx < pages.count - 1 {
            return pages[idx + 1]
        } else {
            return nil
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(of: viewController) else { return nil }
        if idx > 0 {
            return pages[idx - 1]
        } else {
            return nil
        }
    }
    
}
