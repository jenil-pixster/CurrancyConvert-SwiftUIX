//
//  OnBoadScreenView.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI

struct OnBoadScreenView: View {
    
    @StateObject private var viewModel = OnBoardScreenViewModel()
    
    var body: some View {
        ZStack {
            Color.lightGray.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Welcome to\nCurrency Convert!")
                    .appTextStyle(size: 34, weight: .heavy)
                    .multilineTextAlignment(.center)
                    .opacity(viewModel.showTitle ? 1 : 0)
                    .offset(y: viewModel.showTitle ? 0 : -16)

                Spacer()

                IllustrationCard
                    .padding(.horizontal, 24)
                        .opacity(viewModel.showIllustration ? 1 : 0)
                        .scaleEffect(viewModel.showIllustration ? (viewModel.isPulsing ? 1.07 : 1.0) : 0.85)

                Spacer(minLength: 60)

                descriptionText
                    .padding(.horizontal, 28)
                    .opacity(viewModel.showDescription ? 1 : 0)
                    .offset(y: viewModel.showDescription ? 0 : 16)

                Spacer()

                Button(action: viewModel.getStartedTapped) {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(red: 0.29, green: 0.42, blue: 0.94))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .padding(.horizontal, 24)
                .opacity(viewModel.showButton ? 1 : 0)
                .offset(y: viewModel.showButton ? 0 : 20)
                .navigationDestination(isPresented: $viewModel.isPushOnHomeScreen) {
                    HomeView()
                        .navigationBarBackButtonHidden()
                }
            }
            .padding(.top, 30)
            .onAppear {
                viewModel.startEntranceAnimation()
            }
        }
    }
}

#Preview {
    OnBoadScreenView()
}

extension OnBoadScreenView {
    @ViewBuilder
    private var descriptionText: some View {
        Text("Instantly convert between over \n\(highlightedPortion) Currency Convert is your one-stop solution for effortless currency conversions.")
            .appTextStyle(size: 18, weight: .medium)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }

    @ViewBuilder
    private var highlightedPortion: Text {
        Text("150 currencies.")
            .foregroundColor(Color(red: 0.29, green: 0.42, blue: 0.94))
            .italic()
            .bold()
    }
    
    @ViewBuilder
    private var IllustrationCard: some View {
        Image(.illustrator)
            .resizable()
            .scaledToFit()
            .padding(16)
    }
}
