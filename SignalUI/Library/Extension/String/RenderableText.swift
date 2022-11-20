//
//  RenderableText.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 19/09/2022.
//

import Foundation
import UIKit

public protocol RenderableText {
	
	var content: String { get }
	func render(target: Any?)
	func styled(_ attributes:[NSAttributedString.Key : Any]) -> NSAttributedString
}

public extension Dictionary where Self.Key == NSAttributedString.Key, Self.Value == Any {
	
	static func attributed(font: UIFont,
					color: UIColor = .black,
					lineSpacing: CGFloat? = nil,
					alignment: NSTextAlignment? = nil) -> Self {
		var attributes: [NSAttributedString.Key : Any] = [:]
		
		attributes[.font] = font
		
		attributes[.foregroundColor] = color
		
		if lineSpacing != nil || alignment != nil {
			let paragraph: NSMutableParagraphStyle = .init()
			paragraph.lineSpacing = lineSpacing ?? 0
			paragraph.alignment = alignment ?? .natural
			attributes[.paragraphStyle] = paragraph
		}
		
		return attributes
	}
	
	
}

public extension RenderableText {
	
	func styled(
		font: UIFont,
		color: UIColor = .white,
		lineSpacing: CGFloat? = nil,
		alignment: NSTextAlignment? = nil
	) -> NSAttributedString {
		styled(.attributed(font: font, color: color, lineSpacing: lineSpacing, alignment: alignment))
	}
	
	
	var generateLabel: UILabel {
		let label = UILabel()
		render(target: label)
		return label
	}
	
}

extension String: RenderableText {
	
    public var content: String { self }
	
    public func styled(_ attributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
		NSAttributedString(string: self, attributes: attributes)
	}
	
	public func styled(font: CustomFonts, color: UIColor, size: CGFloat) -> NSAttributedString {
		let attributes: [NSAttributedString.Key:Any] = [
			.font: font.fontBuilder(size: size) ?? .systemFont(ofSize: size),
			.foregroundColor: color,
		]
		
		return .init(string: self, attributes: attributes)
	}
	
    public func render(target: Any?) {
		switch target {
		case let button as UIButton:
			button.setTitle(self, for: .normal)
		case let label as UILabel:
			label.text = self
		case let textField as UITextField:
			textField.placeholder =  self
		default:
			break
		}
	}
	
}

extension NSAttributedString: RenderableText {
	
	
    public var content: String { string }
	
    public func styled(_ attributes: [Key : Any]) -> NSAttributedString {
		let copy = NSMutableAttributedString(attributedString: self)
		copy.setAttributes(attributes, range: .init(location: 0, length: copy.length))
		return .init(attributedString: copy)
	}
	
	func styled(font: CustomFonts, color: UIColor, size: CGFloat) -> NSAttributedString {
		let attributes: [NSAttributedString.Key:Any] = [
			.font: font.fontBuilder(size: size) ?? .systemFont(ofSize: size),
			.foregroundColor: color,
		]
	
		let attributedString = NSMutableAttributedString(attributedString: self)
		attributedString.addAttributes(attributes, range: .init(location: 0, length: attributedString.length))
		return .init(attributedString: attributedString)
	}
	
    public func render(target: Any?) {
		switch target {
		case let button as UIButton:
			button.setAttributedTitle(self, for: .normal)
		case let label as UILabel:
			label.attributedText = self
		case let textField as UITextField:
			textField.attributedPlaceholder = self
		default:
			break
		}
	}
	
}
