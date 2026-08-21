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
    let systemName: String
    var body: some View {
        Button {
            
        } label: {
            systemImage(systemName)
                .foregroundColor(.white)
                .frame(size: CGSize(width: 20, height: 20))
        }
        .frame(size: CGSize(width: 40, height: 40))
        .safe_glassEffect(.clear, .regular)
    }
}
