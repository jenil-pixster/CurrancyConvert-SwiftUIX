//
//  HomeViewModel.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import Combine
import SwiftyUIX

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var availableBalance: Double = 0
    
    @Published var baseCurrency = "EUR"
    @Published var targetCurrency = "INR"
    
    @Published var historyItems: [HistoryItemModel] = []
    @Published var isHistoryExpanded = false
    @Published var isLoading = false
    @Published var showPad = false
    @Published var padMode: PadMode = .deposit
    @Published var errorMessage: String?
    
    @Published var headerHeight: CGFloat = 0
    
    private let service = ExchangeRateService.shared
    
    func openPadView(mode: PadMode) {
        padMode = mode
        withAnimation {
            showPad = true
        }
    }
    
    func closePadView() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            showPad = false
        }
    }
    
    func toggleHistoryExpansion() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            isHistoryExpanded.toggle()
        }
    }
    
    // MARK: - Transaction entry point (called from CustomPadView's confirm)
    
    func confirmTransaction(amount: Double, currency: String, mode: PadMode) async -> PadConfirmResult {
        switch mode {
        case .deposit:
            return await performDeposit(amount: amount, currency: currency)
        case .withdraw:
            return performWithdraw(amount: amount)
        }
    }
    
    private func performDeposit(amount: Double, currency: String) async -> PadConfirmResult {
        guard amount > 0 else {
            Log.debug("Enter a valid amount")
            return .failure("Enter a valid amount")
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let convertedINR: Double
            if currency == "INR" {
                convertedINR = amount
            } else {
                let rate = try await service.fetchRate(base: currency, target: "INR")
                convertedINR = amount * rate
            }
            
            availableBalance += convertedINR
            
            let item = HistoryItemModel(
                transactionId: generateTransactionId(),
                date: formattedToday(),
                amount: amount,
                currencyCode: currency,
                convertedAmountINR: convertedINR,
                type: .deposit
            )
            historyItems.insert(item, at: 0)
            
            return .success
        } catch {
            Log.debug("Couldn't fetch exchange rate. Please try again.")
            return .failure("Couldn't fetch exchange rate. Please try again.")
        }
    }
    
    private func performWithdraw(amount: Double) -> PadConfirmResult {
        guard availableBalance > 0 else {
            Log.debug("Insufficient balance")
            return .failure("Insufficient balance")
        }
        guard amount > 0 else {
            Log.debug("Enter a valid amount")
            return .failure("Enter a valid amount")
        }
        guard amount <= availableBalance else {
            Log.debug("Insufficient funds")
            return .failure("Insufficient funds")
        }
        
        availableBalance -= amount
        availableBalance = max(availableBalance, 0)
        
        let item = HistoryItemModel(
            transactionId: generateTransactionId(),
            date: formattedToday(),
            amount: amount,
            currencyCode: "INR",
            convertedAmountINR: amount,
            type: .withdraw
        )
        historyItems.insert(item, at: 0)
        
        return .success
    }
    
    private func generateTransactionId() -> String {
        "ID\(Int.random(in: 10...99))\(String(UUID().uuidString.prefix(5)).uppercased())"
    }
    
    private func formattedToday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: Date())
    }
    
    /// Pure calculation: given the live drag offset, returns the resolved top padding for the card.
    func cardTopPadding(dragOffset: CGFloat, fullPadding: CGFloat, halfPadding: CGFloat) -> CGFloat {
        let basePadding = isHistoryExpanded ? fullPadding : halfPadding
        let proposed = basePadding + dragOffset
        return min(max(proposed, fullPadding), halfPadding)
    }
    
    /// Decision logic for what happens when the drag ends.
    func handleCardDragEnded(translationHeight: CGFloat, predictedTranslationHeight: CGFloat) {
        let dragAmount = translationHeight
        let dragVelocity = predictedTranslationHeight - translationHeight
        
        let dragThreshold: CGFloat = 40
        let velocityThreshold: CGFloat = 100
        
        if !isHistoryExpanded {
            if dragAmount < -dragThreshold || dragVelocity < -velocityThreshold {
                setHistoryExpanded(true)
            }
        } else {
            if dragAmount > dragThreshold || dragVelocity > velocityThreshold {
                setHistoryExpanded(false)
            }
        }
    }
    
    func setHistoryExpanded(_ expanded: Bool) {
        withAnimation {
            isHistoryExpanded = expanded
        }
    }
}
