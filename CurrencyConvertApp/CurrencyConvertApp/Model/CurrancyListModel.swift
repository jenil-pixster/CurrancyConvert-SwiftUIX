//
//  CurrancyListModel.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI

// MARK: - Models
struct CurrancyListModel: Identifiable {
    let id = UUID()
    let type: TransactionType
    let title: String
    let date: String
    let currancyType: String
    let amount: Double
}
