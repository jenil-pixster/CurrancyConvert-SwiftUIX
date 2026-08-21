//
//  PurchesViewModel.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 21/08/26.
//

import SwiftUI
import Combine
import SwiftyUIX
import SwiftyStoreKit

final class PurchesViewModel: ObservableObject {
    
    @Published var isLoading : Bool = false
    @Published var isPurchasing: Bool = false
    @Published var errorMessage: String?
    @Published var selectedPurchesType: purchesType = .yearly

    @Published var testimonialPageCount: Int = 7
    @Published var testimonialPageIndex: Int = 1
    
    var yearlyPurchaseID = PurchaseModel.shared.getPurchaseID(value: Constants.yearly)
    var weeklyPurchaseID = PurchaseModel.shared.getPurchaseID(value: Constants.weekly)

    init() {
        // provide app delegate for implementing purchase delegate methods
        PurchaseModel.shared.delegate = self
    }
    
    //MARK: yealry Purches:
    func getYearlyPrice() -> String {
        return self.yearlyPurchaseID?.getPriceString() ?? "$59.99"
    }
    
    func getYearlySplitPrice() -> String {
        return self.yearlyPurchaseID?.getsplitPrice() ?? "$1.25"
    }
    
    func yealryPurchaseAction() {
        if let yearlyPurchaseID {
            self.purchase(yearlyPurchaseID)
        }
    }
    
    //MARK: Weekly Purches:
    func getWeeklyPrice() -> String {
        return self.weeklyPurchaseID?.getPriceString() ?? "$9.99"
    }
    
    func weeklyPurchaseAction() {
        if let weeklyPurchaseID {
            self.purchase(weeklyPurchaseID)
        }
    }
    
    //start purchasing for purchase id
    func purchase(_ purchaseID : PurchaseId) {
        PurchaseModel.shared.purchase(purchaseID)
    }
    
    // Check Restore Purchase for all purchase IDs
    // show alert : if you want to show alert to user
    func restorePurchase() {
        PurchaseModel.shared.verifySubscriptions(showAlerts: true)
    }
    
//    // If you wish, you can choose to check restore purchase for specific ID/IDs
//    // show alert : if you want to show alert to user
//    func restorePurchaseForYearly() {
//        if let yearlyPurchaseID {
//            PurchaseModel.shared.verifySubscriptions([yearlyPurchaseID.purchaseId], showAlerts: true)
//        }
//    }
    
    //MARK: Next and Close button methods
    func continueTapped() async {

    }

    func closeTapped() {
        
    }
}

//MARK: In App Purches Model Deletgate
extension PurchesViewModel: PurchaseModelDelegate {
    func purchase(didStartLoading isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func purchase(didPurchaseSuccessWith result: PurchaseDetails, purchaseID: PurchaseId) {
        Log.success("*** Purchased success \(purchaseID.purchaseId)")
    }
   
    func purchase(didPurchaseFailWith error: any Error) {
        Log.error("*** Purchased failed \(error.localizedDescription)")
    }
    
    func purchase(didVerifySubscriptionsFor result: VerifySubscriptionResult) {
        Log.debug("*** Verify:- \(result)")
    }
    
    func purchase(id: String, didReceiveReceiptFor receipt: String) {
        Log.debug("*** Genarate receptID: \(id) - Receipt: \(receipt)")
    }
    
    func purchase(didVerifySubscriptionsFor error: any Error) {
        Log.error(error.localizedDescription)
    }
    
    func didPriceUpdated() {
        print("*** Update Price")
    }
}
