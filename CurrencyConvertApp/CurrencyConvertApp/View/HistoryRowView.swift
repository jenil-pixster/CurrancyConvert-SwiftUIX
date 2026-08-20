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

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(item.isConversion ? .lightRed : .lightGreen)
                    .frame(size: CGSize(width: 42, height: 42))
                
                Image(item.isConversion ? .withdraw : .deposit)
                    .foregroundColor(item.isConversion ? .red : .green)
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
                Text("$\(Int(item.amountUSD))")
                    .font(.system(size: 16, weight: .bold))
                if let converted = item.convertedAmount {
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.system(size: 9))
                        Text("₹\(String(format: "%.0f", converted))")
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
}

#Preview {
    HistoryRowView(item: HistoryItemModel(transactionId: "ID21W234R3", date: "12 Apr 2024", amountUSD: 24, isConversion: false))
}
