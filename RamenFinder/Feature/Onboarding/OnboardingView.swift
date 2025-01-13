//
//  OnboardingView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/12/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var currentPage: Int = 0 // 현재 페이지 상태 추가

    private let onboardingItems: [OnboardingData] = [
        OnboardingData(
            title: "서울 라멘 매장 추천",
            description: "서울에 있는 라멘 매장들을 추천 받고 매장 정보를 제공합니다.",
            imageName: "foodStore"
        ),
        OnboardingData(
            title: "내 근처 라멘 매장",
            description: "내 근처에 있는 매장들을 손쉽게 볼 수 있습니다.",
            imageName: "map"
        ),
        OnboardingData(
            title: "마음에 드는 매장 찜하기",
            description: "마음에 드는 매장을 찜하고 관리할 수 있습니다.",
            imageName: "rating"
        )
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingItems.count, id: \.self) { index in
                    let item = onboardingItems[index]
                    VStack(spacing: 20) {
                        Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()

                        Text(item.title)
                            .font(.title)
                            .fontWeight(.bold)

                        Text(item.description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding()
                    .tag(index)
                }
                
                VStack(spacing: 20) {
                    Text("모두 준비되었습니다!")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("지금 바로 시작해보세요.")
                        .font(.body)
                        .multilineTextAlignment(.center)

                    Button(action: {
                        isOnboardingCompleted = true
                    }) {
                        Text("게스트로 시작하기")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(CustomColor.primary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                }
                .tag(onboardingItems.count)
            }
            .tabViewStyle(PageTabViewStyle())

            //MARK: Page Indicator
            HStack(spacing: 8) {
                ForEach(0...onboardingItems.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? CustomColor.primary : Color.gray)
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.top, 20)
        }
    }
}

//#Preview {
//    OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
//}
