//
//  SearchBar.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/12/2022.
//

import Foundation
import UIKit

extension UISearchController {
    
    func standardStyling(placeholder: String = "Explore") {
        searchBar.searchTextField.font = CustomFonts.medium.fontBuilder(size: 16)
        searchBar.searchTextField.attributedPlaceholder = placeholder.body1Medium() as? NSAttributedString
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.border(color: .surfaceBackgroundInverse, borderWidth: 1.25, cornerRadius: 8)
        searchBar.searchTextField.leftView = nil
        automaticallyShowsCancelButton = false
    }
    
}
