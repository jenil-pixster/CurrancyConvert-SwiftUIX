//
//  Enums.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."

        case .invalidResponse:
            return "Invalid server response."

        case .decodingError:
            return "Unable to decode response."
        }
    }
}

enum PadMode {
    case deposit
    case withdraw
}

enum PadConfirmResult {
    case success
    case failure(String)
}

enum TransactionType {
    case deposit
    case withdraw
}

enum purchesType {
    case yearly
    case weekly
}
