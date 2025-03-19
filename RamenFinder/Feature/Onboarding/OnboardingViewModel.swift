//
//  OnboardingViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 1/30/25.
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0 // 현재 페이지 상태
    @Published var isOnboardingCompleted: Bool = false // 온보딩 완료 상태

    let onboardingItems: [OnboardingData] = [
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

    func completeOnboarding() {
        withAnimation {
            isOnboardingCompleted = true
        }
    }
}
