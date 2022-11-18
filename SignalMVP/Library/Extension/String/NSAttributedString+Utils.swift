//
//  NSAttributedString+Utils.swift
//  baraka-styleui
//
//  Created by Krishna Venkatramani on 19/11/2022.
//

import Foundation
import UIKit

//MARK: - UIImage_NSTextAttachment
extension UIImage {
    
    func toText(fontHeight: CGFloat = 0) -> NSAttributedString {
        let attachment = NSTextAttachment(image: self)
        if let img = attachment.image {
            attachment.bounds = .init(origin: .init(x: 0, y: (fontHeight - img.size.height).half), size: img.size)
        }
        return .init(attachment: attachment)
    }
}

//MARK: - NSAttributedString
extension NSAttributedString {
    
    func appending(_ text: RenderableText) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        
        if let str = text as? String {
            copy.append(NSAttributedString(string: str))
        } else if let attrStr = text as? NSAttributedString {
            copy.append(attrStr)
        }
        
        return .init(attributedString: copy)
    }
    
    func addImage(_ image: UIImage) -> NSAttributedString {
        image.toText().appending(" ").appending(self)
    }
    
    static func + (lhs: UIImage, rhs: NSAttributedString) -> NSAttributedString {
        lhs.toText().appending(" ").appending(rhs)
    }
    
    static func + (lhs: NSAttributedString, rhs: UIImage) -> NSAttributedString {
        lhs.appending(" ").appending(rhs.toText())
    }
    
}
