//
//  CustomPadViewModel.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import Combine

final class CustomPadViewModel: ObservableObject {
    @Published var amountText: String = ""          // actual value — starts empty
    @Published var selectedCurrency: String = "USD"
    @Published var isCurrencyListVisible: Bool = false

    private var hasDecimalPoint: Bool = false

    let currencyOptions: [CurrencyOption] = [
        CurrencyOption(code: "USD"),
        CurrencyOption(code: "AED"),
        CurrencyOption(code: "AFN"),
        CurrencyOption(code: "ALL"),
        CurrencyOption(code: "AMD")
    ]

    // What the UI actually displays — falls back to "0.0" only when empty
    var displayText: String {
        amountText.isEmpty ? "0.0" : amountText
    }

    // MARK: - Keypad actions

    func digitTapped(_ digit: String) {
        amountText += digit
    }

    func decimalTapped() {
        guard !hasDecimalPoint else { return }
        amountText += amountText.isEmpty ? "0." : "."
        hasDecimalPoint = true
    }

    func clearAllTapped() {
        amountText = ""
        hasDecimalPoint = false
    }

    func deleteLastTapped() {
        guard !amountText.isEmpty else { return }
        if amountText.last == "." {
            hasDecimalPoint = false
        }
        amountText.removeLast()
    }

    // MARK: - Currency dropdown

    func toggleCurrencyList() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            isCurrencyListVisible.toggle()
        }
    }

    func selectCurrency(_ code: String) {
        selectedCurrency = code
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            isCurrencyListVisible = false
        }
    }

    // MARK: - Confirm
    func confirmTapped() {
        print("click button")
    }
}
