//
//  TweetStorage.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation


class TweetStorage {
	
	static var selectedTweet: TweetCellModel? = nil {
		didSet {
			if selectedTweet != nil {
				NotificationCenter.default.post(name: .showTweet, object: nil)
			}
		}
	}
	
}
