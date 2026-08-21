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
    @Published var userName = "Alex Walker"
    @Published var greeting = "Good Morning"
    @Published var availableBalance: Double = 0

    @Published var baseCurrency = "EUR"
    @Published var targetCurrency = "INR"

    @Published var historyItems: [HistoryItemModel] = []
    @Published var isHistoryExpanded = false
    @Published var isLoading = false
    @Published var showPad = false
    @Published var errorMessage: String?
    
    @Published var headerHeight: CGFloat = 0

    private let service = ExchangeRateService.shared

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
    
    func openPadView() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            showPad = true
        }
    }
    
    func closePadView() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            showPad = false
        }
    }
}
