//
//  OnBoardScreenViewModel.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import Combine
import SwiftyUIX

final class OnBoardScreenViewModel: ObservableObject {
    @Published var showTitle = false
    @Published var showIllustration = false
    @Published var showDescription = false
    @Published var showButton = false
    @Published var isPulsing = false
    @Published var navigateToHome = false
    
    private let titleDelay: Double = 0
    private let illustrationDelay: Double = 0.25
    private let descriptionDelay: Double = 0.5
    private let buttonDelay: Double = 0.7
    private let entranceTotalDuration: Double = 1.3
    
    func startEntranceAnimation() {
        withAnimation(.easeOut(duration: 0.5).delay(titleDelay)) {
            showTitle = true
        }
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(illustrationDelay)) {
            showIllustration = true
        }
        withAnimation(.easeOut(duration: 0.5).delay(descriptionDelay)) {
            showDescription = true
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(buttonDelay)) {
            showButton = true
        }
        
        Thread.runAfter(entranceTotalDuration) { [weak self] in
            self?.startContinuousIllustrationLoop()
        }
    }
    
    func checkOnboardingStatus() {
        if UserDefaults.isPushOnHomeScreen {
            navigateToHome = true
        }
    }
    
    private func startContinuousIllustrationLoop() {
        withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
            isPulsing = true
        }
    }
    
    func getStartedTapped() {
        UserDefaults.isPushOnHomeScreen = true
        checkOnboardingStatus()
    }
}
