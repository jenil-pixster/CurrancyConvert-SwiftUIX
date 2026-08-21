//
//  PurchesViewModel.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 21/08/26.
//

import SwiftUI
import Combine
import SwiftyUIX

enum newPurchesID {
    static let yearly = "com.maximaapps.printer.proyearly"
    static let weekly = "com.maximaapps.printer.proweekly"
}

@MainActor
final class PurchesViewModel: ObservableObject {

    // MARK: - Published state (View binds to these)
    @Published var plans: [SubscriptionPlan] = [.yearly, .weekly]
    @Published var selectedPlanID: String = SubscriptionPlan.yearly.id
    @Published var isPurchasing: Bool = false
    @Published var errorMessage: String?

    @Published var testimonialPageCount: Int = 7
    @Published var testimonialPageIndex: Int = 1

    var selectedPlan: SubscriptionPlan? {
        plans.first { $0.id == selectedPlanID }
    }

    func selectPlan(_ plan: SubscriptionPlan) {
        selectedPlanID = plan.id
    }

    func continueTapped() async {
        Log.info(#function)
    }

    func restoreTapped() async {
        Log.info(#function)
    }

    func closeTapped() {
        Log.info(#function)
    }
}
