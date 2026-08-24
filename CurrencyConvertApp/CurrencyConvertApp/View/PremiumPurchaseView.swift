//
//  PremiumPurchaseView.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 21/08/26.
//

import SwiftUI
import SwiftyUIX

struct PremiumPurchaseView: View {
    
    var userSelectedType: UserType = .reviewer
    var onCloseEvent: (()->())
    @StateObject var viewModel = PurchesViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
               bgPrinterView
                
                VStack(spacing: 0) {
                    topBar
                    midContentView
                }
            }
            plansSection
            continueButton
            footer
        }
        .onAppear {
            Log.debug("userSelectedType: \(userSelectedType)")
            viewModel.userType = userSelectedType
        }
        .background(Color(.systemBackground))
        .disabled(viewModel.isPurchasing)
        .overlay {
            if viewModel.isPurchasing {
                ProgressView().scaleEffect(1.2)
            }
        }
        .alert("Something went wrong", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    // MARK: - Sections
    @ViewBuilder
    private var bgPrinterView: some View {
        GeometryReader { geo in
            let w = geo.size.width
            
            // Top-left printer (small)
            Image(.imgBgPrinter)
                .resizable()
                .scaledToFit()
                .frame(width: w * 0.08)
                .position(x: w * 0.12, y: geo.size.height * 0.15)
            
            // Bottom-left printer (larger)
            Image(.imgBgPrinter)
                .resizable()
                .scaledToFit()
                .frame(width: w * 0.1)
                .position(x: w * 0.11, y: geo.size.height * 0.38)
            
            // Top-right printer (small)
            Image(.imgBgPrinter)
                .resizable()
                .scaledToFit()
                .frame(width: w * 0.08)
                .position(x: w * 0.88, y: geo.size.height * 0.18)
            
            // Bottom-right printer (larger)
            Image(.imgBgPrinter)
                .resizable()
                .scaledToFit()
                .frame(width: w * 0.1)
                .position(x: w * 0.89, y: geo.size.height * 0.50)
        }
    }
    
    @ViewBuilder
    private var topBar: some View {
        HStack {
            if viewModel.isUIUpdate || userSelectedType == .reviewer {
                Button {
                    onCloseEvent()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                        .padding(8)
                        .background(Circle().fill(Color(.systemGray5)))
                }
                .transition(.opacity)
            } else {
                // Placeholder to keep layout stable
                Color.clear
                    .frame(width: 32, height: 32)
            }

            Spacer()

            Button {
                viewModel.restorePurchase()
            } label: {
                Text("Restore")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .transition(.opacity)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var midContentView: some View {
        VStack(spacing: 24) {
            printerImage
            titleText
            testimonialCard
            pageDots.padding(.bottom)
        }
    }
    
    private var printerImage: some View {
        Image(.imgPrinter)
    }

    private var titleText: some View {
        Text("Unlimited All Features")
            .appTextStyle(size: 26, weight: .bold)
            .padding(.top, 20)
    }

    private var testimonialCard: some View {
        TestimonialCardView(
            currentIndex: $viewModel.testimonialPageIndex,
            testimonials: viewModel.testimonials
        )
    }

    @ViewBuilder
    private var pageDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<viewModel.testimonials.count, id: \.self) { index in
                Circle()
                    .fill(index == viewModel.testimonialPageIndex ? Color.blue : Color(.systemGray4))
                    .squareFrame(size: 6)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.testimonialPageIndex)
            }
        }
    }

    @ViewBuilder
    private var plansSection: some View {
        VStack(spacing: 12) {
            // Split-price subtitle hidden until isUIReady = true (after 3s)
            PlanRowItem(
                title: "Yearly \(viewModel.getYearlyPrice())",
                subTitle: "only \(viewModel.yearlyPurchaseID?.getsplitPrice(withOutPostFix: true) ?? "nil") per week",
                isSelected: viewModel.selectedPurchesType == .yearly,
                isSelectedYearly: true,
                showSubTitle: userSelectedType != .reviewer
            )
            .onTapGesture {
                viewModel.selectedPurchesType = .yearly
            }

            PlanRowItem(
                title: userSelectedType == .reviewer ? "weekly \(viewModel.getWeeklyPrice())" : "3-day free",
                subTitle: "then, \(viewModel.getWeeklyPrice()) per week",
                isSelected: viewModel.selectedPurchesType == .weekly,
                isSelectedYearly: false,
                showSubTitle: userSelectedType != .reviewer
            )
            .onTapGesture {
                viewModel.selectedPurchesType = .weekly
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 32)
    }

    private var continueButton: some View {
        Button {
            viewModel.continueTapped()
        } label: {
            Text("Continue")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 27)
                        .fill(Color(red: 0.29, green: 0.5, blue: 0.75))
                )
        }.horizontalPadding(20)
        .padding(.top, 20)
    }

    @ViewBuilder
    private var footer: some View {
        VStack(spacing: 10) {
            Text("Auto-renewable subscription. Cancel anytime.")
                .font(.footnote)
                .foregroundColor(.primary)

            HStack(spacing: 8) {
                Button("Privacy policy") {}
                Text("|").foregroundColor(.secondary)
                Button("Terms of use") {}
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .verticalPadding(15)
    }
}

#Preview {
    PremiumPurchaseView(userSelectedType: .reviewer, onCloseEvent: {})
}
