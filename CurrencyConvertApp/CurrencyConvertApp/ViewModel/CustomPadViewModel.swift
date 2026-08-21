//
//  CustomPadViewModel.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import Combine

final class CustomPadViewModel: ObservableObject { 
    @Published var amountText: String = ""
    @Published var selectedCurrency: String
    @Published var isCurrencyListVisible: Bool = false
    @Published var isProcessing: Bool = false

    // MARK: - Alert state (failure only)
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""

    let isCurrencyFixed: Bool
    let mode: PadMode
    private var hasDecimalPoint: Bool = false
    private var onConfirm: ((Double, String) async -> PadConfirmResult)?
    private var onSuccessClose: (() -> Void)?

    let currencyOptions: [CurrencyOption] = [
        CurrencyOption(code: "USD"),
        CurrencyOption(code: "EUR"),
        CurrencyOption(code: "GBP"),
        CurrencyOption(code: "AED"),
        CurrencyOption(code: "AFN"),
        CurrencyOption(code: "ALL"),
        CurrencyOption(code: "AMD")
    ]

    init(
        mode: PadMode,
        fixedCurrency: String? = nil,
        onConfirm: ((Double, String) async -> PadConfirmResult)? = nil,
        onSuccessClose: (() -> Void)? = nil
    ) {
        self.mode = mode
        self.isCurrencyFixed = fixedCurrency != nil
        self.selectedCurrency = fixedCurrency ?? "USD"
        self.onConfirm = onConfirm
        self.onSuccessClose = onSuccessClose
    }

    var displayText: String {
        amountText.isEmpty ? "0.0" : amountText
    }

    var parsedAmount: Double {
        Double(amountText) ?? 0
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
        guard !isCurrencyFixed else { return }
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
    @MainActor
    func confirmTapped() async {
        guard !isProcessing else { return }

        guard parsedAmount > 0 else {
            presentAlert(title: "Invalid Amount", message: "Please enter a valid amount.")
            return
        }

        isProcessing = true
        let result = await onConfirm?(parsedAmount, selectedCurrency) ?? .failure("Something went wrong")
        isProcessing = false

        switch result {
        case .success:
            onSuccessClose?()
        case .failure(let message):
            presentAlert(title: "Error", message: message)
        }
    }

    private func presentAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
