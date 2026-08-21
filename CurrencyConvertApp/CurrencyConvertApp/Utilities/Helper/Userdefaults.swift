//
//  Userdefaults.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 21/08/26.
//

import Foundation

extension UserDefaults {

    //MARK: manage the user id using the userDefault
    ///Avoid the Appstorage and ScenceStorage
//    static var userID: String? {
//        get {return self.standard.string(forKey: #function)}
//        set { self.standard.setValue(newValue, forKey: #function) }
//    }
    
    static var isPushOnHomeScreen: Bool {
        get {return self.standard.bool(forKey: #function)}
        set { self.standard.setValue(newValue, forKey: #function) }
    }
}
