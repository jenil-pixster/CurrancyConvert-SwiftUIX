//
//  ExchangeRateResponseModel.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import Foundation

struct ExchangeRateResponseModel: Codable {
    let result: String
    let base_code: String
    let target_code: String
    let conversion_rate: Double
}
