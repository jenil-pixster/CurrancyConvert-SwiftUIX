//
//  SplashScreenView.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import SwiftyUIX

struct SplashScreenView: View {
    
    @StateObject private var viewModel = SplashScreenViewModel()
    var isPushOnHomeScreen = UserDefaults.isPushOnHomeScreen
    
    var body: some View {
        NavigationStack {
            if viewModel.isActive {
                Group {
                    if isPushOnHomeScreen {
                        HomeView()
                    } else {
                        OnBoadScreenView()
                    }
                }
                .transition(.opacity)
            } else {
                splashView
                    .onAppear {
                       viewModel.startAnimation()
                    }
            }
        }
    }
    
    @ViewBuilder
    var splashView: some View {
        ZStack {
            Color.lightGray.ignoresSafeArea()
            
            Image(.splash)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .scaleEffect(viewModel.logoScale)
                .opacity(viewModel.logoOpacity)
        }
    }
}

#Preview {
    SplashScreenView()
}
