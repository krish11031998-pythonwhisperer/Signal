//
//  String+Date.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 08/01/2023.
//

import Foundation

extension String  {
    
    var timestamp: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        var date = dateFormatter.date(from: self)
        
        if let timestamp = date?.timestamp {
            return timestamp
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        date = dateFormatter.date(from: self)
        
        if let timestamp = date?.timestamp {
            return timestamp
        }
        
        return self
    }
}
