//
//  CustomPadView.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import SwiftyUIX

struct CustomPadView: View {
    @StateObject private var viewModel = CustomPadViewModel()
    var onClose: (() -> Void)? = nil
    var onClick: (() -> Void)? = nil
    
    private let keyHeight: CGFloat = 72
    private let keySpacing: CGFloat = 12
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 22) {
                grabHandle
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.height > 40 {
                                    onClose?()
                                }
                            }
                    )
                
                amountRow
                
                ZStack(alignment: .topLeading) {
                    keypadGrid
                    
                    if viewModel.isCurrencyListVisible {
                        currencyDropdown
                    }
                }
            }
            .horizontalPadding(20)
            .padding(.top, 20)
            .padding(.bottom, 50 + geo.safeAreaInsets.bottom)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color(red: 0.07, green: 0.09, blue: 0.16))
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .frame(height: 480)
    }
    
    // MARK: - Grab handle
    private var grabHandle: some View {
        Capsule()
            .fill(Color.white.opacity(0.15))
            .frame(width: 40, height: 5)
    }
    
    // MARK: - Currency selector + amount field
    private var amountRow: some View {
        HStack(spacing: keySpacing) {
            Button {
                viewModel.toggleCurrencyList()
            } label: {
                HStack(spacing: 6) {
                    Text(currencySymbol(for: viewModel.selectedCurrency))
                        .font(.system(size: 18, weight: .bold))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(width: 90, height: keyHeight)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(red: 0.29, green: 0.42, blue: 0.94))
                )
            }
            
            Text(viewModel.amountText.isEmpty ? "0" : viewModel.amountText)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: keyHeight)
                .padding(.horizontal, 18)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.white)
                )
                .allowsHitTesting(false)
        }
    }
    
    // MARK: - Currency dropdown list
    private var currencyDropdown: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.currencyOptions) { option in
                Button {
                    viewModel.selectCurrency(option.code)
                } label: {
                    Text(option.code)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.08, green: 0.11, blue: 0.2))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 46)
                }
                
                if option.id != viewModel.currencyOptions.last?.id {
                    Divider().padding(.horizontal, 12)
                }
            }
        }
        .frame(width: 148)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(red: 0.93, green: 0.95, blue: 1.0))
        )
        .shadow(color: .black.opacity(0.2), radius: 10, y: 6)
        .transition(.opacity.combined(with: .move(edge: .top)))
        .zIndex(10)
    }
    
    // MARK: - Keypad grid
    private var keypadGrid: some View {
        HStack(spacing: keySpacing) {
            VStack(spacing: keySpacing) {
                HStack(spacing: keySpacing) {
                    numberKey("7")
                    numberKey("8")
                    numberKey("9")
                }
                HStack(spacing: keySpacing) {
                    numberKey("4")
                    numberKey("5")
                    numberKey("6")
                }
                HStack(spacing: keySpacing) {
                    numberKey("1")
                    numberKey("2")
                    numberKey("3")
                }
                HStack(spacing: keySpacing) {
                    numberKey("0")
                    numberKey("00")
                    decimalKey
                }
            }
            
            VStack(spacing: keySpacing) {
                acKey
                deleteKey
                confirmKey
            }
            .frame(width: keyHeight)
        }
    }
    
    // MARK: - Individual keys
    private func numberKey(_ digit: String) -> some View {
        Button {
            viewModel.digitTapped(digit)
        } label: {
            Text(digit)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: keyHeight)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(red: 0.19, green: 0.22, blue: 0.3))
                )
        }
    }
    
    private var decimalKey: some View {
        Button {
            viewModel.decimalTapped()
        } label: {
            Circle()
                .fill(Color.white)
                .frame(width: 8, height: 8)
                .frame(maxWidth: .infinity)
                .frame(height: keyHeight)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(red: 0.19, green: 0.22, blue: 0.3))
                )
        }
    }
    
    private var acKey: some View {
        Button {
            viewModel.clearAllTapped()
        } label: {
            Text("AC")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: keyHeight * 2 + keySpacing)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(red: 0.19, green: 0.22, blue: 0.3))
                )
        }
    }
    
    private var deleteKey: some View {
        Button {
            viewModel.deleteLastTapped()
        } label: {
            Image(systemName: "delete.left.fill")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: keyHeight)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(red: 0.94, green: 0.4, blue: 0.35))
                )
        }
    }
    
    private var confirmKey: some View {
        Button {
            onClick?()
            onClose?()
        } label: {
            Image(systemName: "checkmark")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: keyHeight, height: keyHeight)
                .background(
                    Circle()
                        .fill(Color(red: 0.35, green: 0.78, blue: 0.47))
                )
        }
    }
    
    // MARK: - Helper
    private func currencySymbol(for code: String) -> String {
        switch code {
        case "USD": return "$"
        case "INR": return "₹"
        case "EUR": return "€"
        case "GBP": return "£"
        default: return code
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.29, green: 0.42, blue: 0.94).ignoresSafeArea()
        VStack {
            Spacer()
            CustomPadView()
        }
    }
    .ignoresSafeArea(edges: .bottom)
}
