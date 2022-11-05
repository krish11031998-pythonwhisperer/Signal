//
//  CoinStorage.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 04/11/2022.
//

import Foundation

class MentionStorage {
    
    public static var selectedMention: MentionModel? = nil {
        didSet {
            NotificationCenter.default.post(name: .showMention, object: nil)
        }
    }
    
}
