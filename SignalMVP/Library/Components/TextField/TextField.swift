//
//  TextField.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/12/2022.
//

import Foundation
import UIKit
import Combine

class TextField: UITextField {
    
    enum Constants {
        static var height: CGFloat = 50
    }
    
    private var type: TextFieldType

    init(placeHolder: String? = nil, type: TextFieldType = .email) {
        self.type = type
        super.init(frame: .zero)
        setupTextField()
        self.attributedPlaceholder = placeHolder?.styled(font: .regular, color: .gray, size: 16)
        configureBasedOnType()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overriden Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 7.5, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 7.5, dy: 0)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let size = rightView?.frame.size ?? .zero
        return .init(origin: .init(x: bounds.maxX - size.width - 7.5, y: bounds.midY - size.height.half), size: size)
    }
    
    //MARK: - Protected Methods
    
    private func setupTextField() {
        textColor = .textColor
        font = CustomFonts.medium.fontBuilder(size: 16)
        clearsOnBeginEditing = true
        border(color: .surfaceBackgroundInverse, borderWidth: 1.25, cornerRadius: Constants.height.half.half)
        setHeight(height: Constants.height)
        layer.masksToBounds = true
    }
    
    private func configureBasedOnType() {
        isSecureTextEntry = type.secureText
        rightView = type.rightSideView(self)
        rightViewMode = type.rightSideViewMode
        addGestureToRightSideView()
    }
    
    func addGestureToRightSideView() {
        guard let validRightView = rightView else { return }
        validRightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightSideGesture)))
        validRightView.isUserInteractionEnabled = true
    }
    
    @objc
    private func rightSideGesture() {
        self.type.handleRightSideTap(self)
    }
}
