//
//  IconButton.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import SwiftyUIX

// MARK: - Reusable Icon button
struct IconButton: View {
    let name: String
    var action: (()->Void)
    
    var body: some View {
        Text(name)
            .foregroundColor(.white)
            .padding(10)
            .squareFrame(size: 40)
            .safe_glassEffect(.clear, .regular, isintractive: true, clipShape: .capsule, tintColor: nil)
            .onTapGesture {
                action()
            }
    }
}
