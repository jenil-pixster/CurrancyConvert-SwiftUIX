//
//  AppDelegate.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 21/08/26.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setUpProScreen()
        return true
    }

}

extension AppDelegate {
    private func setUpProScreen() {
        //Restore and verify premimum purches id
        self.setUpCompleteTransactions()
        //your app's sharedSecret  
        PurchaseModel.shared.sharedSecret = Constants.sharedSecret
    
        //mention all you purchase id with their default prices
        PurchaseModel.shared.purchaseIds =  [
            .init(type: .yearly, purchaseId: Constants.yearly, priceDefaultValue: "$59.99", priceDefaultValueDouble: 59.99, needSplitPrice: true, splitPriceInToUnit: .week),
            .init(type: .weekly, purchaseId: Constants.weekly, priceDefaultValue: "$9.99", priceDefaultValueDouble: 9.99, needSplitPrice: true, splitPriceInToUnit: .week),
        ]
        
        //run this folder to get all purchase ids details and price
        PurchaseModel.shared.getPrice()
    }
}
