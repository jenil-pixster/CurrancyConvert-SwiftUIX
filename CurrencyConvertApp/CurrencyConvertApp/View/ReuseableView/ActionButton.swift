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
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isFilled ? Color(red: 0.08, green: 0.11, blue: 0.2) : Color.white)
                )
        }
    }
}
