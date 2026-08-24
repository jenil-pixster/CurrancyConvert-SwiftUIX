//
//  TestimonialCardView.swift
//  CurrencyConvertApp
//
//  Created by Jenil - iOS Developer on 24/08/26.
//

import SwiftUI

// MARK: - TestimonialCardView

struct TestimonialCardView: View {

    // Binding so the parent (PremiumPurchaseView / ViewModel) can stay in sync
    @Binding var currentIndex: Int

    let testimonials: [Testimonial]

    // Auto-timer
    @State private var autoTimer: Timer? = nil

    // Drag state for manual swipe
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(Array(testimonials.enumerated()), id: \.offset) { index, item in
                cardView(for: item)
                    .offset(x: cardOffset(for: index))
                    .animation(.spring(response: 0.5, dampingFraction: 0.82), value: currentIndex)
                    .animation(.spring(response: 0.5, dampingFraction: 0.82), value: dragOffset)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .gesture(dragGesture)
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
    }

    // MARK: - Card Offset

    private func cardOffset(for index: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let relativeIndex = CGFloat(index - currentIndex)
        return relativeIndex * screenWidth + dragOffset
    }

    // MARK: - Card View

    @ViewBuilder
    private func cardView(for item: Testimonial) -> some View {
        HStack(spacing: 0) {

            // Left laurel image
            Image(.leftSide)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 100)
                .padding(.leading, 8)

            // Center content
            VStack(spacing: 6) {
                // Stars
                Image(.stars)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)

                // Quote
                Text("\"\(item.quote)\"")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                // Description
                Text(item.description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                // Author name
                Text(item.author)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 8)

            // Right laurel image
            Image(.rightSide)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 100)
                .padding(.trailing, 8)
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Drag Gesture

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                stopTimer()
                dragOffset = value.translation.width
            }
            .onEnded { value in
                let threshold: CGFloat = 50
                withAnimation(.spring(response: 0.5, dampingFraction: 0.82)) {
                    if value.translation.width < -threshold {
                        currentIndex = min(currentIndex + 1, testimonials.count - 1)
                    } else if value.translation.width > threshold {
                        currentIndex = max(currentIndex - 1, 0)
                    }
                    dragOffset = 0
                }
                startTimer()
            }
    }

    // MARK: - Auto Timer

    private func startTimer() {
        stopTimer()
        autoTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.82)) {
                if currentIndex < testimonials.count - 1 {
                    currentIndex += 1
                } else {
                    currentIndex = 0
                }
            }
        }
    }

    private func stopTimer() {
        autoTimer?.invalidate()
        autoTimer = nil
    }
}
