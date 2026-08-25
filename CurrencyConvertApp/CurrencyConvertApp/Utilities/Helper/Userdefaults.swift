//
//  Userdefaults.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 21/08/26.
//

import Foundation

extension UserDefaults {
    static var isPushOnHomeScreen: Bool {
        get {return self.standard.bool(forKey: #function)}
        set { self.standard.setValue(newValue, forKey: #function) }
    }
    
    static var isReviewVersion: Bool {
        get {return self.standard.bool(forKey: #function)}
        set { self.standard.setValue(newValue, forKey: #function) }
    }

}
