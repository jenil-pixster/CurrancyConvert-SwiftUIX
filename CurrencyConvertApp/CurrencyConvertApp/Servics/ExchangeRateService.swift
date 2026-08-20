//
//  ExchangeRateService.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import Foundation

final class ExchangeRateService {
    static let shared = ExchangeRateService()
    private init() {}

    private let apiKey = "8cea16c76b5c2669eae114d1"

    func fetchRate(base: String, target: String) async throws -> Double {
        guard let url = URL(string: "https://v6.exchangerate-api.com/v6/\(apiKey)/pair/\(base)/\(target)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(ExchangeRateResponseModel.self, from: data)
        return decoded.conversion_rate
    }
}
