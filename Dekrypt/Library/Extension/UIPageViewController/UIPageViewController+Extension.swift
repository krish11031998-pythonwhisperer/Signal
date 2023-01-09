//
//  UIPageViewController+Extension.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 08/01/2023.
//

import Foundation
import UIKit
import Combine

//MARK: - UIPageViewController+Navigate
extension UIPageViewController {
    
    @discardableResult
    func goToNextPage(completion: Callback? = nil) -> UIViewController? {
        guard let current = viewControllers?.first,
              let nextPage = dataSource?.pageViewController(self, viewControllerAfter: current)
        else { return nil}
        setViewControllers([nextPage], direction: .forward, animated: true, completion: { _ in completion?() })
        return nextPage
    }
    
    @discardableResult
    func goToPrevPage(completion: Callback? = nil) -> UIViewController? {
        guard let current = viewControllers?.first,
              let prevPage = dataSource?.pageViewController(self, viewControllerBefore: current)
        else { return nil}
        setViewControllers([prevPage], direction: .reverse, animated: true, completion: { _ in completion?() })
        return prevPage
    }

}

//MARK: - UIPageViewController+Scrolling
extension UIPageViewController {

    func enableSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = true
            }
        }
    }

    func disableSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
}
