//
//  HomeView.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 20/08/26.
//

import SwiftUI
import SwiftyUIX

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    private let headerToCardSpacing: CGFloat = 28
    private let fullCardTopPadding: CGFloat = 0

    var body: some View {
        ZStack(alignment: .top) {
            Color.blue.ignoresSafeArea()

            headerContent
                .opacity(viewModel.isHistoryExpanded ? 0 : 1)
                .animation(.easeOut(duration: 0.25), value: viewModel.isHistoryExpanded)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear { viewModel.headerHeight = proxy.size.height }
                            .onChange(of: proxy.size.height) { _, newValue in
                                viewModel.headerHeight = newValue
                            }
                    }
                )

            historyCard
                .padding(.top, viewModel.isHistoryExpanded ? fullCardTopPadding : viewModel.headerHeight + headerToCardSpacing)

            if viewModel.showPad {
                padOverlay
                    .zIndex(20)
            }
        }
        .onAppear {
//            viewModel.loadInitialHistory()
           
        }
    }

    // MARK: - Pad overlay + backdrop
    @ViewBuilder
    private var padOverlay: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture {
                    viewModel.closePadView()
                }

            CustomPadView {
                viewModel.closePadView()
            } onClick: {
                Task {
                    await viewModel.fetchConversionRates()
                }
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    // MARK: - Header
    @ViewBuilder
    private var headerContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                HStack(spacing: 10) {
                    Image(.profile)
                        .resizable()
                        .frame(size: CGSize(width: 50, height: 50))
                        .foregroundColor(.white)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(viewModel.greeting) 👋")
                            .appTextStyle(color: .white, size: 14)
                        Text(viewModel.userName)
                            .appTextStyle(color: .white, size: 16, weight: .bold)
                    }
                }

                Spacer()

                HStack(spacing: 12) {
                    IconButton(systemName: "bell")
                    IconButton(systemName: "gearshape.fill")
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Available Balance")
                    .appTextStyle(color: .white, size: 14)
                Text("₹ \(viewModel.availableBalance, specifier: "%.2f")")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundColor(.white)
            }

            HStack(spacing: 14) {
                ActionButton(title: "WITHDRAW", isFilled: false) {
                    viewModel.openPadView()
                }
                ActionButton(title: "DEPOSIT", isFilled: true) {
                    viewModel.openPadView()
                }
            }
        }
        .padding(.horizontal, 24)
    }

    // MARK: - History Card
    @ViewBuilder
    private var historyCard: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .verticalPadding(14)

            HStack {
                Text("History")
                    .appTextStyle(size: 20, weight: .bold)

                Spacer()

                Button {
                    viewModel.toggleHistoryExpansion()
                } label: {
                    Text(viewModel.isHistoryExpanded ? "Collapse" : "Expand")
                        .appTextStyle(color: .gray, size: 14)
                }
            }
            .padding(.horizontal, 24)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.historyItems) { item in
                        HistoryRowView(item: item)
                    }
                }
                .horizontalPadding(20)
                .padding(.top, 16)
                .padding(.bottom, 30)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color(.systemGray6))
        )
        .ignoresSafeArea(edges: .bottom)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height < -40 && !viewModel.isHistoryExpanded {
                        viewModel.toggleHistoryExpansion()
                    } else if value.translation.height > 40 && viewModel.isHistoryExpanded {
                        viewModel.toggleHistoryExpansion()
                    }
                }
        )
    }
}

#Preview {
    HomeView()
}
