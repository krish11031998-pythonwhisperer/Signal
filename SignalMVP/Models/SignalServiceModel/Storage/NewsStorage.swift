//
//  NewsStorage.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/09/2022.
//

import Foundation


class NewsStorage {
	
	public static var selectedNews: NewsModel? = nil {
		didSet {
			if selectedNews != nil {
				NotificationCenter.default.post(name: .showNews, object: nil)
			}
		}
	}
}
