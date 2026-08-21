//
//  PremiumPurchaseView.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 21/08/26.
//

import SwiftUI
import SwiftyUIX

struct PremiumPurchaseView: View {
    
    var onCloseEvent: (()->())
    @StateObject var viewModel = PurchesViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            topBar
            midContentView
            plansSection
            continueButton
            footer
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
    private var topBar: some View {
        HStack {
            Button{
                onCloseEvent()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(Circle().fill(Color(.systemGray5)))
            }
            
            Spacer()
            
            Button {
                viewModel.restorePurchase()
            } label: {
                Text("Restore")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
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
        Image(.imgPremium)
    }

    private var pageDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<viewModel.testimonialPageCount, id: \.self) { index in
                Circle()
                    .fill(index == viewModel.testimonialPageIndex ? Color.blue : Color(.systemGray4))
                    .frame(width: 6, height: 6)
            }
        }
    }

    private var plansSection: some View {
        VStack(spacing: 12) {
            PlanRowItem(title: "Yearly \(viewModel.getYearlyPrice())", subTitle: "only \(viewModel.getYearlySplitPrice()) per week", isSelected: viewModel.selectedPurchesType == .yearly, isSelectedYearly: true)
                .onTapGesture {
                    viewModel.selectedPurchesType = .yearly
                }
            
            PlanRowItem(title: "3-day free", subTitle: "then, \(viewModel.getWeeklyPrice()) per week", isSelected: viewModel.selectedPurchesType == .weekly, isSelectedYearly: false)
                .onTapGesture {
                    viewModel.selectedPurchesType = .weekly
                }
        }
        .padding(.horizontal, 20)
        .padding(.top, 32)
    }

    private var continueButton: some View {
        Button {
            Task { await viewModel.continueTapped() }
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
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private var footer: some View {
        VStack(spacing: 10) {
            Text("Auto-renewable subscription. Cancel anytime.")
                .font(.footnote)
                .foregroundColor(.primary)

            HStack(spacing: 8) {
                Button("Privacy policy") { /* open URL */ }
                Text("|").foregroundColor(.secondary)
                Button("Terms of use") { /* open URL */ }
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding(.top, 12)
        .padding(.bottom, 16)
    }
}

//#Preview {
//    PremiumPurchaseView()
//}
//
