//
//  Testimonial.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 24/08/26.
//

import Foundation

// MARK: - Testimonial Model
struct Testimonial: Identifiable {
    let id: Int
    let quote: String
    let description: String
    let author: String
}
