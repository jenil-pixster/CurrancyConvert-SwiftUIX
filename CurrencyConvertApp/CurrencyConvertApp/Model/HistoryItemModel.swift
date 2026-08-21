//
//  HistoryItem.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI

struct HistoryItemModel: Identifiable {
    let id = UUID()
    let transactionId: String
    let date: String
    let amount: Double
    let currencyCode: String  
    let convertedAmountINR: Double
    let type: TransactionType
}
