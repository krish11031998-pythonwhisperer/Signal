//
//  SearchBar.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 27/09/2022.
//

import Foundation
import UIKit

class CustomSearchBar: UISearchBar {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupSearchBar()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupSearchBar()
	}
	
	private func setupSearchBar() {
		searchTextField.font = .systemFont(ofSize: 25, weight: .medium)
		setBackgroundImage(.init(), for: .any, barMetrics: .default)
		
		let searchImage = UIImageView(image: .init(systemName: "magnifyingglass.circle.fill"))
		searchImage.setFrame(.init(squared: 20))
		let paddedSearchImage = searchImage.embedInView(insets: .init(by: 5))
		searchTextField.leftView = paddedSearchImage

		searchTextField.textColor = .white
		searchTextField.tintColor = .white
		
		searchTextField.border(color: .white, borderWidth: 1, cornerRadius: 12)
	}
}
