//
//  SingularModel.swift
//  Passportphoto
//
//  Created by Moksh on 17/05/24.
//

#if canImport(Singular)
import Foundation
import Singular

class SingularModel {
    static var shared = SingularModel()
    
    func customRevenue(_ purchaseID : String, transaction: Any? = nil) {
        let purchaseID = PurchaseModel.shared.getPurchaseID(value: purchaseID)
        if let doublePrice = purchaseID?.priceDouble {
            if let transaction {
                Singular.iapComplete(transaction)
            }
            
            // Sajid have implemented this
            Singular.customRevenue(purchaseID?.type.rawValue, currency: "\( Locale.current.currencyCode ?? purchaseID?.currencySymbol ?? "USD")", amount: doublePrice)
        }
    }
    
    func configureSingular(apiKey : String,secret : String, userID: String? = nil) {
        let singularConfig : SingularConfig = SingularConfig(apiKey: apiKey, andSecret: secret)
        singularConfig.skAdNetworkEnabled = true
        if let userID {
            Singular.setCustomUserId(userID)
        }
        Singular.start(singularConfig)
        Singular.event("session_start")
    }
}
#else
//    #error("Please install \"pod 'Singular'\"")
#endif
