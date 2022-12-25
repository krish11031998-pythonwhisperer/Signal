//
//  ImageCatalogue.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 27/09/2022.
//

import Foundation
import UIKit

extension UIImage {
	enum Catalogue: String {
		case arrowUpLeft = "arrow-up-left"
		case arrowUpRight = "arrow-up-right"
		case arrowUp = "arrow-up"
		case arrowDown = "arrow-down"
		case chartBar = "chart-bar"
		case chartSquareBarOutline = "chart-square-bar-outline"
		case chartSquareBar = "chart-square-bar"
		case check = "check"
		case chevronDown = "cheveron-down"
		case chevronLeft = "cheveron-left"
		case chevronRight = "cheveron-right"
		case clock = "clock"
		case cloudDownload = "cloud-download"
		case cog = "cog"
		case creditCard = "credit-card"
		case creditCardOutline = "credit-card-outline"
		case dotsVertical = "dots-vertical"
		case duplicate = "duplicate"
		case eyeOff = "eye-off"
		case eye = "eye"
		case eth = "eth"
		case heartOutline = "heart-outline"
		case heart = "heart"
		case homeOutline = "home-outline"
		case home = "home"
		case link = "link"
		case lockClosed = "lock-closed"
		case mail = "mail"
		case menu = "menu-alt-3"
		case minus = "minus"
		case moon = "moon"
		case pencil = "pencil-alt"
		case photograph = "photograph"
		case play = "play"
		case plus = "plus"
		case qrCode = "qrcode"
		case searchOutline = "search-outline"
		case search = "search"
		case share = "share"
		case shieldCheck = "shield-check"
		case switchHorizontal = "switch-horizontal"
		case twitter = "twitter"
		case trash = "trash"
		case trendingUp = "trending-up"
		case userOutline = "user-outline"
		case user = "user"
		case viewGridAdd = "view-grid-add"
		case viewGrid = "view-grid"
		case xMark = "x"
        case like, tweetShare, comments, retweet
	}
}

extension UIImage.Catalogue {
	
	var image: UIImage { .init(named: self.rawValue) ?? .solid(color: .black.withAlphaComponent(0.125), frame: .smallestSquare) }
	
	func generateView(size: CGSize = .smallestSquare) -> UIView { image.imageView(size: size) }
	
}
