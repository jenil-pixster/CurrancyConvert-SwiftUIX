//
//  HomeViewModel.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    // MARK: - Profile / Balance
    @Published var userName = "Alex Walker"
    @Published var greeting = "Good Morning"
    @Published var availableBalance: Double = 24224.90

    // MARK: - Currency pair (dynamic)
    @Published var baseCurrency = "EUR"
    @Published var targetCurrency = "INR"

    // MARK: - History
    @Published var historyItems: [HistoryItemModel] = []
    @Published var isHistoryExpanded = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = ExchangeRateService.shared

    func loadInitialHistory() {
        historyItems = [
            HistoryItemModel(transactionId: "ID21W234R3", date: "12 Apr 2024", amountUSD: 24, isConversion: false),
            HistoryItemModel(transactionId: "ID213EE30",  date: "11 Apr 2024", amountUSD: 12, isConversion: true),
            HistoryItemModel(transactionId: "ID21334R3",  date: "2 Apr 2024",  amountUSD: 46, isConversion: false),
            HistoryItemModel(transactionId: "ID2132R42",  date: "23 Mar 2024", amountUSD: 21, isConversion: false),
            HistoryItemModel(transactionId: "ID213EE30",  date: "11 Mar 2024", amountUSD: 32, isConversion: true),
            HistoryItemModel(transactionId: "ID21W234R3", date: "10 Mar 2024", amountUSD: 24, isConversion: false)
        ]
    }

    func fetchConversionRates() async {
        isLoading = true
        errorMessage = nil
        do {
            let rate = try await service.fetchRate(base: baseCurrency, target: targetCurrency)
            for index in historyItems.indices where historyItems[index].isConversion {
                historyItems[index].convertedAmount = historyItems[index].amountUSD * rate
            }
        } catch {
            errorMessage = "Couldn't load rates: \(error.localizedDescription)"
        }
        isLoading = false
    }

    /// Call this to change the pair dynamically, e.g. updateCurrencyPair(base: "USD", target: "INR")
    func updateCurrencyPair(base: String, target: String) {
        baseCurrency = base
        targetCurrency = target
        Task { await fetchConversionRates() }
    }

    func toggleHistoryExpansion() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            isHistoryExpanded.toggle()
        }
    }
}
