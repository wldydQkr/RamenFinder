//
//  OnboardingView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/12/25.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel = OnboardingViewModel()
    @Binding var isOnboardingCompleted: Bool

    var body: some View {
        VStack {
            // MARK: TabView
            TabView(selection: $viewModel.currentPage) {
                ForEach(Array(viewModel.onboardingItems.enumerated()), id: \.element.title) { index, item in
                    OnboardingPageView(item: item)
                        .tag(index) // 인덱스 기반 태그 설정
                }

                // 마지막 화면
                VStack(spacing: 20) {
                    Text("모두 준비되었습니다!")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("지금 바로 시작해보세요.")
                        .font(.body)
                        .multilineTextAlignment(.center)

                    Button(action: {
                        viewModel.completeOnboarding()
                        isOnboardingCompleted = true
                    }) {
                        Text("시작하기")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(CustomColor.primary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                }
                .tag(viewModel.onboardingItems.count) // 마지막 페이지 태그 설정
            }
            .tabViewStyle(PageTabViewStyle())
            .animation(.easeInOut, value: viewModel.currentPage)

            // MARK: Page Indicator
            HStack(spacing: 8) {
                ForEach(0...viewModel.onboardingItems.count, id: \.self) { index in
                    Circle()
                        .fill(index == viewModel.currentPage ? CustomColor.primary : Color.gray)
                        .frame(width: 10, height: 10)
                        .onTapGesture {
                            withAnimation {
                                viewModel.currentPage = index
                            }
                        }
                }
            }
            .padding(.top, 20)
        }
    }
}
