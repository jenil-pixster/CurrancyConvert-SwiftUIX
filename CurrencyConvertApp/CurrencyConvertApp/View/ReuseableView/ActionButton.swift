//
//  ActionButton.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import SwiftyUIX

// MARK: - Reusable Action button
struct ActionButton: View {
    let title: String
    let isFilled: Bool
    var action: (() -> Void)
    
    var body: some View {
        Button {
            withAnimation { action() }
        } label: {
            Text(title)
                .appTextStyle(color: isFilled ? .white : .fontBlack , size: 14, weight: .bold)
                .fullWidth()
                .verticalPadding(18)
                .background(isFilled ? Color.text.primary : Color.white)
                .cornerRadius(20)
        }
    }
}
