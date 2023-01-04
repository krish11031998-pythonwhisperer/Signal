//
//  SearchBar.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/12/2022.
//

import Foundation
import UIKit

extension UISearchController {
    
    var searchImage: UIImageView {
        UIImage.Catalogue.searchOutline.image.withTintColor(.textColor).imageView(size: .init(squared: 16))
    }
    
    
    func standardStyling(placeholder: String = "Explore") {
        searchBar.backgroundImage = .init()
        searchBar.backgroundColor = .clear

        searchBar.searchTextField.font = CustomFonts.medium.fontBuilder(size: 16)
        searchBar.searchTextField.attributedPlaceholder = placeholder.body1Medium() as? NSAttributedString
        searchBar.searchTextField.border(color: .surfaceBackgroundInverse, borderWidth: 1, cornerRadius: 16)
        searchBar.searchTextField.leftView = searchImage.embedInView(insets: .init(top: 0, left: 6, bottom: 0, right: 0))
        
        searchBar.autocorrectionType = .no
        searchBar.textContentType = .none
        searchBar.smartDashesType = .no
        searchBar.smartQuotesType = .no
        searchBar.smartInsertDeleteType = .no
        
        searchBar.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 12,
            leading: 0,
            bottom: 0.0,
            trailing: 0
        )

        
        automaticallyShowsCancelButton = false
    }
    
}
