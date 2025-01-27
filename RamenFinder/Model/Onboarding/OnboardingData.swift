//
//  OnboardingData.swift
//  RamenFinder
//
//  Created by 박지용 on 1/12/25.
//

import Foundation

struct OnboardingData: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct onboardingItems {
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
}
