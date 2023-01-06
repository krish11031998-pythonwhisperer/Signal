//
//  SymbolImage.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 27/09/2022.
//

import Foundation
import UIKit

class SymbolImage: UIView {
	
	private lazy var image: UIImageView = {
		let imgView = UIImageView()
		imgView.clipsToBounds = true
		imgView.backgroundColor = .gray
		return imgView
	}()
	
	private lazy var symbolName: UILabel = { .init() }()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	private func setupView() {
		let stack: UIStackView = .HStack(subViews:[image, symbolName], spacing: 8, alignment: .center)
		addSubview(stack)
		setFittingConstraints(childView: stack, insets: .zero)
		symbolName.isHidden = true
	}
	
    func imgURL(ticker: String) -> String {
        "https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@1a63530be6e374711a8554f31b17e4cb92c25fa5/128/color/\(ticker.lowercased()).png"
    }
	
	public func configureView(symbol: String, imgSize: CGSize = .smallestSquare, label: RenderableText? = nil) {
		
		image.setFrame(imgSize)
		image.cornerRadius = min(imgSize.width, imgSize.height).half
        UIImage.loadImage(url: imgURL(ticker: symbol), at: image, path: \.image)

		if let validLabel = label {
			validLabel.render(target: symbolName)
			symbolName.isHidden = false
		}
		
	}
	
}
