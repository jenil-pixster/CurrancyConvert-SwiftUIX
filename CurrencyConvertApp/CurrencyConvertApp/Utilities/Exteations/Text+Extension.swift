//
//  Text+Extension.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI

extension Text {
    func appTextStyle(color: Color = .fontBlack, size: CGFloat = 16, weight: Font.Weight = .regular) -> Text {
        self
            .font(fontForWeight(weight, size: size))
            .foregroundColor(color)
    }

    private func fontForWeight(_ weight: Font.Weight, size: CGFloat) -> Font {
        switch weight {
        case .bold, .semibold, .heavy:
            return .arialHebrewBold(size: size)
        case .light, .thin, .ultraLight:
            return .arialHebrewLight(size: size)
        default:
            return .arialHebrew(size: size)
        }
    }
}
