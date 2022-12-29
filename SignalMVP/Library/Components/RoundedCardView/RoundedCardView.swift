//
//  RoundedCardView.swift
//  baraka-styleui
//
//  Created by Krishna Venkatramani on 27/10/2022.
//

import Foundation
import UIKit
import Combine

fileprivate extension UILabel {
    func renderWithText(_ str: RenderableText?) {
        guard let validStr = str else { return }
        validStr.render(target: self)
        if isHidden { isHidden = false }
    }
}

class RoundedCardView: UIView {
    
    //MARK: - Properties
    private lazy var titleLabel: UILabel = { .init() }()
    private lazy var subTitleLabel: UILabel = { .init() }()
    private lazy var captionLabel: UILabel = { .init() }()
    private lazy var subCaptionLabel: UILabel = { .init() }()
    private var leadingView: UIView?
    private var trailingView: UIView? 
    private lazy var mainStack: UIStackView = { .HStack(subViews: [leadingStack, spacer, trailingStack].compactMap { $0 }, spacing: 8, alignment: .center) }()
    private let spacer: UIView = { .spacer() }()
    private lazy var leadingStack: UIStackView = {
        let stack: UIStackView = .VStack(subViews: [titleLabel, subTitleLabel],spacing: 4, alignment: .leading)
        stack.hideChildViews()
        return stack
    }()
    
    private lazy var trailingStack: UIStackView = {
        let stack: UIStackView = .VStack(subViews: [captionLabel, subCaptionLabel], spacing: 4, alignment: .trailing)
        stack.hideChildViews()
        return stack
    }()
    
    private var cardView: UIView!
    
    
    //MARK: - Exposed Properties
    
    var appearance: RoundedCardAppearance = .default {
        didSet { setupAppearance() }
    }
    
    init(appearance: RoundedCardAppearance = .default) {
        self.appearance = appearance
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        mainStack.hideChildViews()
        addSubview(mainStack)
        setFittingConstraints(childView: mainStack, insets: appearance.insets)
        spacer.isHidden = true
        setupAppearance()
    }
    
    private func setupAppearance() {
        layer.cornerRadius = appearance.cornerRadius
        backgroundColor = appearance.backgroundColor
        mainStack.spacing = appearance.iterSpacing
        mainStack.alignment = appearance.alignment
        leadingStack.spacing = appearance.lineSpacing
        trailingStack.spacing = appearance.lineSpacing
        if let validHeight = appearance.cardHeight.height {
            setHeight(height: validHeight)
        }
    }
    

    private func configureLeadingView(title: RenderableText?,
                                      subTitle: RenderableText?,
                                      view: UIView?) {
        titleLabel.renderWithText(title)
        subTitleLabel.renderWithText(subTitle)
        
        subTitleLabel.numberOfLines = 3
        
        if title != nil || subTitle != nil {
            leadingStack.isHidden = false
        }
        
        if let validLeadingView = view {
            if leadingView != nil {
                leadingView?.removeFromSuperview()
            }
            mainStack.insertArrangedSubview(validLeadingView, at: 0)
            leadingView = validLeadingView
        }
    }
    
    private func configureTrailingingView(caption: RenderableText?,
                                      subCaption: RenderableText?,
                                      view: UIView?) {
        captionLabel.renderWithText(caption)
        subCaptionLabel.renderWithText(subCaption)
        
        if caption != nil || subCaption != nil {
            if spacer.isHidden { spacer.isHidden =  false }
            trailingStack.isHidden = false
        }
        
        if let validTrailingView = view {
            if trailingView != nil {
                trailingView?.removeFromSuperview()
            }
            mainStack.addArrangedSubview(validTrailingView)
            trailingView = validTrailingView
        }
    }
    
    @discardableResult
    public func configureView(with model: RoundedCardViewConfig) -> [AnyCancellable]? {
        let leadingView = model.leadingView?.view
        let trailingView = model.trailingView?.view
        configureLeadingView(title: model.title, subTitle: model.subTitle, view: leadingView?.0)
        configureTrailingingView(caption: model.caption, subCaption: model.subCaption, view: trailingView?.0)
        return [leadingView?.1, trailingView?.1].compactMap { $0 }
    }
    
}


//MARK: - RoundedCardViewUpdates

extension RoundedCardView {
        
    private func animateInsertTrailingView(newView: UIView, withAnimation: Animation = .fadeIn()) {
        trailingView = newView
        mainStack.addArrangedSubview(trailingView!)
        mainStack.layoutSubviews()
        trailingView!.layer.animate(withAnimation, removeAfterCompletion: false)
    }
    
}

//MARK: - RoundedCardView: RoundedCardViewConfigurable

extension RoundedCardView: RoundedCardViewConfigurable {
    
    func updateTitle(newTitle: RenderableText) {
        newTitle.render(target: titleLabel)
    }
    
    func updateSubTitle(newSubTitle: RenderableText) {
        newSubTitle.render(target: subTitleLabel)
    }
    
    func updateCaption(newCaption: RenderableText) {
        newCaption.render(target: captionLabel)
    }
    
    func updateSubCaption(newSubCaption: RenderableText) {
        newSubCaption.render(target: subCaptionLabel)
    }
    
    func updateTrailingView(newView: RoundedCardViewSideView, animate animated: Bool = true, hideTrailingStack: Bool = false) {
        
        trailingStack.isHidden = hideTrailingStack
        
        guard let newSideView = newView.view.0 else { return }
        
        guard animated else {
            self.trailingView?.removeFromSuperview()
            mainStack.addArrangedSubview(newSideView)
            self.trailingView = newSideView
            return
        }
        
        if let trailingView = self.trailingView {
            trailingView.layer.animate(.fadeOut(), removeAfterCompletion: false) { [weak self] in
                self?.trailingView?.removeFromSuperview()
                self?.animateInsertTrailingView(newView: newSideView)
            }
        } else {
            animateInsertTrailingView(newView: newSideView)
        }
    }
    
    func updateTrailingView(newView: RoundedCardViewSideView, insertAnimation: Animation?, exitAnimation: Animation?, hideTrailingStack: Bool = false) {
        
        trailingStack.isHidden = hideTrailingStack
        
        guard let newSideView = newView.view.0 else { return }
        
        guard let animation = insertAnimation else {
            self.trailingView?.removeFromSuperview()
            mainStack.addArrangedSubview(newSideView)
            self.trailingView = newSideView
            return
        }
        
        if let trailingView = self.trailingView {
            trailingView.layer.animate(exitAnimation ?? animation, removeAfterCompletion: false) { [weak self] in
                self?.trailingView?.removeFromSuperview()
                self?.animateInsertTrailingView(newView: newSideView, withAnimation: animation)
            }
        } else {
            animateInsertTrailingView(newView: newSideView, withAnimation: animation)
        }
    }
    
}
