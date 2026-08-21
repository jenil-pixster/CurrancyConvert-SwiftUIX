//
//  PlanRowItem.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 21/08/26.
//

import SwiftUI

enum purchesType {
    case yearly
    case weekly
}

struct PlanRowItem: View {
    let title: String
    let subTitle: String
    let isSelected: Bool
    let isSelectedYearly: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                Text(subTitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            selectionIndicator
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? Color.blue.opacity(0.08) : Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.blue : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
        )
        .overlay(alignment: .topTrailing) {
            Text(isSelectedYearly ? "Best Value" : "Free Trial")
                .font(.caption2.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.blue))
                .offset(x: -12, y: -10)
        }
    }

    private var selectionIndicator: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.blue : Color(.systemGray4), lineWidth: 2)
                .frame(width: 24, height: 24)
            if isSelected {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 24, height: 24)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}
