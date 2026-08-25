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

    // MARK: - Published
    @Published var isLoading: Bool = false
    @Published var isPurchasing: Bool = false
    @Published var errorMessage: String?
    @Published var selectedPurchesType: purchesType = .yearly
    @Published var testimonialPageIndex: Int = 0
    @Published var isUIUpdate: Bool = false
    @Published var isUIReady: Bool = false
    @Published var isReviewVersion = UserDefaults.isReviewVersion

    // MARK: - Computed behaviour flags

    /// Show the split-price subtitle inside plan rows.
    var showSplitPrice: Bool {
        !UserDefaults.isReviewVersion
    }

    /// Show the Restore button in the top-bar.
    var showRestoreButton: Bool {
        UserDefaults.isReviewVersion ? true : isUIReady
    }

    /// Hide the word "free" (and "Free Trial" badge) in plan rows.
    var hideFreeKeyword: Bool {
        UserDefaults.isReviewVersion
    }

    let testimonials: [Testimonial] = [
        Testimonial(id: 0,
                    quote: "This is so good",
                    description: "I really like this app it's easy to use and so amazing. You guys should download it too I really recommend",
                    author: "Tina Hodges"),
        Testimonial(id: 1,
                    quote: "Best currency app!",
                    description: "Absolutely love how fast and accurate the conversions are. Works perfectly even offline.",
                    author: "Marcus Lee"),
        Testimonial(id: 2,
                    quote: "Super easy to use",
                    description: "Clean interface and lightning fast. I use it every day for my business expenses abroad.",
                    author: "Sara Mitchell"),
        Testimonial(id: 3,
                    quote: "Highly recommended",
                    description: "The live rate updates are spot on. Saved me so much time compared to other apps I've tried.",
                    author: "David Patel"),
        Testimonial(id: 4,
                    quote: "A must-have travel tool",
                    description: "Never worry about currency math again. This app handles everything beautifully and is worth every penny.",
                    author: "Emily Carter")
    ]

    var yearlyPurchaseID = PurchaseModel.shared.getPurchaseID(value: Constants.yearly)
    var weeklyPurchaseID = PurchaseModel.shared.getPurchaseID(value: Constants.weekly)

    // MARK: - Init

    init() {
        PurchaseModel.shared.delegate = self
        configureUIVisibility()
        
        print("Split Price: \(yearlyPurchaseID?.getsplitPrice(withOutPostFix: true) ?? "nil")")
    }

    /// Applies the correct timing / visibility based on the chosen user type.
    private func configureUIVisibility() {
        if UserDefaults.isReviewVersion {
            isUIUpdate = true
            isUIReady  = true
        } else {
            isUIUpdate = false
            isUIReady  = false
            Thread.runAfter(3) {
                withAnimation(.easeIn(duration: 0.3)) {
                    self.isUIReady  = true
                    self.isUIUpdate = true
                }
            }
        }
    }
    
    //MARK: yealry Purches:
    func getYearlyPrice() -> String {
        return self.yearlyPurchaseID?.getPriceString() ?? "$59.99"
    }
    
    func getYearlySplitPrice() -> String {
        let getSplitPrice = self.yearlyPurchaseID?.getsplitPrice(withOutPostFix: true) ?? "nil"
//        Log.debug("*** getSplitPrice: \(self.yearlyPurchaseID?.getsplitPrice() ?? "$1.25")")
        return getSplitPrice
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
    
    //MARK: Next and Close button methods
    func continueTapped() {
        Log.debug(selectedPurchesType == .yearly ? yearlyPurchaseID?.purchaseId ?? "" : weeklyPurchaseID?.purchaseId ?? "")
        let selectedID: PurchaseId? = (selectedPurchesType == .yearly) ? yearlyPurchaseID : weeklyPurchaseID
        if let selectedID {
            purchase(selectedID)
        } else {
            Log.error("No PurchaseId available for selected type: \(selectedPurchesType)")
        }
    }
}

//MARK: In App Purches Model Deletgate
extension PurchesViewModel: PurchaseModelDelegate {
    func purchase(didStartLoading isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func purchase(didPurchaseSuccessWith result: PurchaseDetails, purchaseID: PurchaseId) {
        ///Note: If the success the purchase so don't display the purchase view in all screens.
        Log.success("Purchased success \(purchaseID.purchaseId)")
    }
   
    func purchase(didPurchaseFailWith error: any Error) {
        Log.error("Purchased failed \(error.localizedDescription)")
    }
    
    func purchase(didVerifySubscriptionsFor result: VerifySubscriptionResult) {
        Log.debug("Verify:- \(result)")
    }
    
    func purchase(id: String, didReceiveReceiptFor receipt: String) {
        Log.debug("Genarate receptID: \(id) - Receipt: \(receipt)")
    }
    
    func purchase(didVerifySubscriptionsFor error: any Error) {
        Log.error(error.localizedDescription)
    }
    
    func didPriceUpdated() {
        print("*** Update Price")
    }
}
