//
//  SubscriptionPlanModel.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 21/08/26.
//

import SwiftUI

struct SubscriptionPlan: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let badge: String?
    let isBestValue: Bool

    static let yearly = SubscriptionPlan(
        id: "yearly_59_99",
        title: "Yearly $59.99",
        subtitle: "only $1.25 per week",
        badge: "Best Value",
        isBestValue: true
    )

    static let weekly = SubscriptionPlan(
        id: "weekly_trial_9_99",
        title: "3-day free",
        subtitle: "then, $9.99 per week",
        badge: nil,
        isBestValue: false
    )
}
