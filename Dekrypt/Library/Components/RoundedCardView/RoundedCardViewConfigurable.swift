//
//  RoundedCardViewConfigurable.swift
//  baraka-styleui
//
//  Created by Krishna Venkatramani on 31/10/2022.
//

import Foundation
import UIKit

protocol RoundedCardViewConfigurable {
    var appearance: RoundedCardAppearance { get }
    func updateTrailingView(newView: RoundedCardViewSideView, animate: Bool, hideTrailingStack: Bool)
    func updateLeadingView(newView: RoundedCardViewSideView, animate: Bool , hideLeadingStack: Bool)
    func updateTitle(newTitle: RenderableText)
    func updateSubTitle(newSubTitle: RenderableText)
    func updateCaption(newCaption: RenderableText)
    func updateSubCaption(newSubCaption: RenderableText)
    func updateTrailingView(newView: RoundedCardViewSideView, insertAnimation: Animation?, exitAnimation: Animation?, hideTrailingStack: Bool)
    func updateLeadingView(newView: RoundedCardViewSideView, insertAnimation: Animation?, exitAnimation: Animation? , hideLeadingStack: Bool)
}

extension RoundedCardViewConfigurable {
    func updateTrailingView(newView: RoundedCardViewSideView, animate: Bool = true, hideTrailingStack: Bool) {}
    func updateLeadingView(newView: RoundedCardViewSideView, animate: Bool = true, hideLeadingStack: Bool) {}
    func updateTitle(newTitle: RenderableText) {}
    func updateSubTitle(newSubTitle: RenderableText) {}
    func updateCaption(newCaption: RenderableText) {}
    func updateSubCaption(newSubCaption: RenderableText) {}
    func updateTrailingView(newView: RoundedCardViewSideView, insertAnimation: Animation?, exitAnimation: Animation?, hideTrailingStack: Bool) {}
    func updateLeadingView(newView: RoundedCardViewSideView, insertAnimation: Animation?, exitAnimation: Animation?, hideLeadingStack: Bool) {}
}

