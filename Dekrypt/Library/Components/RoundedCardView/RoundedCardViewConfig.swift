//
//  RoundedCardViewConfig.swift
//  baraka-styleui
//
//  Created by Krishna Venkatramani on 27/10/2022.
//

import Foundation
import UIKit
import Combine

//MARK: - RoundedCardHeight
enum RoundedCardHeight {
    case constant(CGFloat)
    case autoDimension
}

extension RoundedCardHeight {
    var height: CGFloat? {
        switch self {
        case .constant(let h):
            return h
        case .autoDimension:
            return nil
        }
    }
}

//MARK: - RoundedCardViewSideView
enum RoundedCardViewSideView {
    case image(url: String? = nil,
               img: UIImage? = nil,
               size: CGSize? = nil,
               cornerRadius: CGFloat = 0,
               bordered: Bool = false,
               borderColor: UIColor = .gray,
               borderWidth: CGFloat = 0.5,
               backgroundColor: UIColor = .clear)
    case solidColor(color: UIColor, size: CGSize, cornerRadius: CGFloat)
    case customView(view: UIView)
}

extension RoundedCardViewSideView {
    var view: (UIView?, AnyCancellable?) {
        switch self {
        case .image(let url, let img, let size, let cornerRadius, let bordered, let borderColor, let borderWidth, let backgroundColor):
            let imgView = UIImageView(image: img)
            var cancellable: AnyCancellable? = nil
            imgView.backgroundColor = backgroundColor
            imgView.contentMode = .center
            imgView.clippedCornerRadius = cornerRadius
            imgView.setFrame(size ?? img?.size ?? .init(squared: 48))
            if bordered {
                imgView.border(color: borderColor, borderWidth: borderWidth)
            }
            if let validUrl = url {
                cancellable = UIImage.loadImage(url: validUrl, at: imgView, path: \.image, resized: size)
            }
            return (imgView, cancellable)
        case .solidColor(let color, let size, let cornerRadius):
            let view = UIView()
            view.backgroundColor = color
            view.setFrame(size)
            view.clippedCornerRadius = cornerRadius
            return (view, nil)
        case .customView(let view):
            return (view, nil)
        }
    }
}

//MARK: - RoundedCardViewConfig
struct RoundedCardViewConfig: RoundedCardViewConfiguration {
    var title: RenderableText?
    var subTitle: RenderableText?
    var caption: RenderableText?
    var subCaption: RenderableText?
    var leadingView: RoundedCardViewSideView?
    var trailingView: RoundedCardViewSideView?

    init (title: RenderableText? = nil,
          subTitle: RenderableText? = nil,
          caption: RenderableText? = nil,
          subCaption: RenderableText? = nil,
          leadingView: RoundedCardViewSideView? = nil,
          trailingView: RoundedCardViewSideView? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.caption = caption
        self.subCaption = subCaption
        self.leadingView = leadingView
        self.trailingView = trailingView
    }
}

protocol RoundedCardViewConfiguration {
    var title: RenderableText? {get set}
    var subTitle: RenderableText? {get set}
    var caption: RenderableText? {get set}
    var subCaption: RenderableText? {get set}
    var leadingView: RoundedCardViewSideView? {get set}
    var trailingView: RoundedCardViewSideView? {get set}
}

extension RoundedCardViewConfiguration {
    var title: RenderableText? { nil }
    var subTitle: RenderableText? { nil }
    var caption: RenderableText? { nil }
    var subCaption: RenderableText? { nil }
    var leadingView: RoundedCardViewSideView? { nil }
    var trailingView: RoundedCardViewSideView? { nil }
}

//MARK: - RoundedCardAppearance
struct RoundedCardAppearance {
    var backgroundColor: UIColor
    var cornerRadius: CGFloat
    var insets: UIEdgeInsets
    var iterSpacing: CGFloat
    var lineSpacing: CGFloat
    var cardHeight: RoundedCardHeight
    var alignment: UIStackView.Alignment
    
    init(backgroundColor: UIColor,
         cornerRadius: CGFloat,
         insets: UIEdgeInsets,
         iterSpacing: CGFloat,
         lineSpacing: CGFloat,
         height: RoundedCardHeight = .autoDimension,
         alignment: UIStackView.Alignment = .center) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.insets = insets
        self.iterSpacing = iterSpacing
        self.lineSpacing = lineSpacing
        self.cardHeight = height
        self.alignment = alignment
    }
}

extension RoundedCardAppearance{
    
    static var `default`: RoundedCardAppearance = .init(backgroundColor: .surfaceBackground, cornerRadius: 8, insets: .init(vertical: 12, horizontal: 16), iterSpacing: 8, lineSpacing: 4, height: .autoDimension)
    
    static var defaultTicker: RoundedCardAppearance = .init(backgroundColor: .surfaceBackground, cornerRadius: 16, insets: .init(vertical: 8, horizontal: 12), iterSpacing: 8, lineSpacing: 4, height: .constant(33))
    
    static var plain: RoundedCardAppearance =  .init(backgroundColor: .surfaceBackground, cornerRadius: 0, insets: .zero, iterSpacing: 10, lineSpacing: 10)
}
