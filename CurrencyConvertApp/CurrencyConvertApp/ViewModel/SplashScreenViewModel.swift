//
//  SplashScreenViewModel.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import Combine
import SwiftyUIX

final class SplashScreenViewModel: ObservableObject {
    @Published var logoScale: CGFloat = 0.6
    @Published var logoOpacity: Double = 0.0
    @Published var isActive: Bool = false

    private let pulseDelay: TimeInterval = 0.5
    private let navigationDelay: TimeInterval = 2

    func startAnimation() {
        animateLogoEntrance()
        schedulePulse()
        scheduleNavigation()
    }

    private func animateLogoEntrance() {
        withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
    }

    private func schedulePulse() {
        Thread.runAfter(pulseDelay) { [weak self] in
            guard let self else { return }
            withAnimation(.easeInOut(duration: 0.4).repeatCount(1, autoreverses: true)) {
                self.logoScale = 1.1
            }
        }
    }

    private func scheduleNavigation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + navigationDelay) { [weak self] in
            guard let self else { return }
            withAnimation(.easeOut(duration: 0.5)) {
                self.isActive = true
            }
        }
    }
}
