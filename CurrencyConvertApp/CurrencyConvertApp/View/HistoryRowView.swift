//
//  HistoryRowView.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import SwiftyUIX

struct HistoryRowView: View {
    let item: HistoryItemModel

    private var isWithdraw: Bool {
        item.type == .withdraw
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(isWithdraw ? .lightRed : .lightGreen)
                    .frame(size: CGSize(width: 42, height: 42))

                Image(isWithdraw ? .withdraw : .deposit)
                    .foregroundColor(isWithdraw ? .red : .green)
                    .frame(size: CGSize(width: 15, height: 15))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(item.transactionId)
                    .font(.system(size: 15, weight: .semibold))
                Text(item.date)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("\(symbol(for: item.currencyCode))\(String(format: "%.2f", item.amount))")
                    .font(.system(size: 16, weight: .bold))

                if item.currencyCode != "INR" {
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.system(size: 9))
                        Text("₹\(String(format: "%.2f", item.convertedAmountINR))")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
        )
    }

    private func symbol(for code: String) -> String {
        switch code {
        case "USD": return "$"
        case "INR": return "₹"
        case "EUR": return "€"
        case "GBP": return "£"
        default: return code + " "
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        HistoryRowView(item: HistoryItemModel(
            transactionId: "ID21W234R3",
            date: "12 Apr 2024",
            amount: 24,
            currencyCode: "INR",
            convertedAmountINR: 24,
            type: .withdraw
        ))
        HistoryRowView(item: HistoryItemModel(
            transactionId: "ID213EE30",
            date: "11 Apr 2024",
            amount: 500,
            currencyCode: "USD",
            convertedAmountINR: 11452,
            type: .deposit
        ))
    }
    .padding()
}
