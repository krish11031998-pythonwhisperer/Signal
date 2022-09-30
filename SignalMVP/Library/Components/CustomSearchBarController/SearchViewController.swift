//
//  SearchViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 27/09/2022.
//

import Foundation
import UIKit

class CustomSearchViewController: UISearchController {
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		let searchBar = {
			let searchBar = CustomSearchBar()
			searchBar.delegate = self
			return searchBar
		}()
		self.setValue(searchBar, forKey: "searchBar")
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	
	
}

extension CustomSearchViewController: UISearchBarDelegate {
	
}
