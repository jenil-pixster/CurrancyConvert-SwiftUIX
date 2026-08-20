//
//  Font+Extension .swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI

extension Font {
    static func arialHebrew(size: CGFloat) -> Font {
        .custom("ArialHebrew", size: size)
    }

    static func arialHebrewBold(size: CGFloat) -> Font {
        .custom("ArialHebrew-Bold", size: size)
    }

    static func arialHebrewLight(size: CGFloat) -> Font {
        .custom("ArialHebrew-Light", size: size)
    }
}
