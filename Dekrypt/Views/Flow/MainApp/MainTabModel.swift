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
	
	static let home: MainTabModel = .init(name: "Home", iconName: .homePage)
	static let tweets: MainTabModel = .init(name: "Tweets", iconName: .twitter)
	static let news: MainTabModel = .init(name: "News", iconName: .news)
	static let events: MainTabModel = .init(name: "Events", iconName: .event)
    static let videos: MainTabModel = .init(name: "Video", iconName: .video)
}


extension MainTabModel {
    var tabImage: UIImage {
        let imgView = UIImageView(image: iconName.image)
        imgView.frame = .init(origin: .zero, size: .init(squared: 24))
        imgView.contentMode = .scaleAspectFit
        return imgView.snapshot
    }

    var tabBarItem: UITabBarItem {
        return .init(title: name, image: tabImage, selectedImage: tabImage)
    }
}
