//
//  MainTabModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 28/09/2022.
//

import Foundation
import UIKit

struct MainTabModel: Equatable {
	let name: String
	let iconName: UIImage.Catalogue

	static func == (lhs: MainTabModel, rhs: MainTabModel) -> Bool {
		lhs.name == rhs.name
	}
	
	static let home: MainTabModel = .init(name: "Home", iconName: .home)
	static let tweets: MainTabModel = .init(name: "Tweets", iconName: .twitter)
	static let news: MainTabModel = .init(name: "News", iconName: .mail)
	static let events: MainTabModel = .init(name: "Events", iconName: .switchHorizontal)
}


extension MainTabModel {
	
	var tabImage: UIImage {
//		let imgView = UIImageView(image: iconName.image.resized(size: .init(squared: 32)))
//		imgView.frame.size = .init(squared: 32)
//		imgView.contentMode = .scaleAspectFit
//		return imgView.snapshot
		iconName.image
	}
}