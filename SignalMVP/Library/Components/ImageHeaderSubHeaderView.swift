//
//  ImageHeaderSubHeaderView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit

struct ImageHeadSubHeaderViewConfig {
	let title: RenderableText?
	let subTitle: RenderableText?
	let img: UIImage?
	let imgUrl: String?
	let imgSize: CGSize
	
	init(title: RenderableText?,
		 subTitle: RenderableText? = nil,
		 img: UIImage? = nil,
		 imgUrl: String? = nil,
		 imgSize: CGSize = .init(squared: 32)) {
		self.title = title
		self.subTitle = subTitle
		self.img = img
		self.imgUrl = imgUrl
		self.imgSize = imgSize
	}
}

class ImageHeadSubHeaderView: UIView {
	
	
	private lazy var title: UILabel = { .init() }()
	private lazy var subTitle: UILabel = { .init() }()
	private lazy var imgView: UIImageView = {
		let img = UIImageView()
		img.clipsToBounds = true
		img.backgroundColor = .gray
		img.contentMode = .scaleAspectFill
		return img
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	
	private func setupView() {
		let headerInfo: UIView = .VStack(subViews: [title, subTitle], spacing: 8, alignment: .leading)
		let header: UIView = .HStack(subViews: [imgView, headerInfo], spacing: 8, alignment: .center)
		
		addSubview(header)
		setFittingConstraints(childView: header, insets: .zero)
	}
	
	
	public func configure(config: ImageHeadSubHeaderViewConfig, radius: CGFloat = 8) {
		
		if let validTitle = config.title {
			validTitle.render(target: title)
		}
		
		if let validSubtitle = config.subTitle {
			validSubtitle.render(target: subTitle)
		}
		
		if let validImg = config.img {
			imgView.image = validImg
			imgView.setFrame(config.imgSize)
			imgView.cornerRadius = radius
		} else if let validUrl = config.imgUrl {
			UIImage.loadImage(url: validUrl, at: imgView, path: \.image)
			imgView.setFrame(config.imgSize)
			imgView.cornerRadius = radius
		}

	}
}
