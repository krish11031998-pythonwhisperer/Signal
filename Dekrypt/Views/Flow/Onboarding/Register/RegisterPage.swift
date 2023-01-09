//
//  RegisterPage.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 08/01/2023.
//

import Foundation
import UIKit


class RegisterPageController: UIPageViewController {
    
    var pages: [UIViewController]
    
    init(pages: [UIViewController]) {
        self.pages = pages
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([pages.first].compactMap { $0 }, direction: .forward, animated: true)
    }
}


extension RegisterPageController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(of: viewController) else { return nil }
        if idx > 0 {
            return pages[idx - 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(of: viewController) else { return nil }
        if idx < pages.count - 1 {
            return pages[idx + 1]
        } else {
            return nil
        }
    }
    
}

