//
//  RamenRecommendationViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 1/25/25.
//

import Foundation
import Combine

class RamenRecommendationViewModel: ObservableObject {
    @Published var selectedFlavor: String? // 맛 선택
    @Published var selectedBase: String?   // 국물 선택
    @Published var selectedIngredient: String? // 재료 선택
    
    @Published var recommendedRamen: Ramen? // 추천 결과

    var isSelectionComplete: Bool {
        selectedFlavor != nil && selectedBase != nil && selectedIngredient != nil
    }

    private let ramens: [Ramen] = [
        Ramen(name: "쇼유 라멘", flavorScore: 8, baseScore: 7, ingredientScore: 6, description: "짭짤한 간장 국물의 도쿄 스타일 라멘"),
        Ramen(name: "미소 라멘", flavorScore: 6, baseScore: 8, ingredientScore: 7, description: "된장의 고소함이 가득한 삿포로 라멘"),
        Ramen(name: "돈코츠 라멘", flavorScore: 7, baseScore: 9, ingredientScore: 8, description: "진하고 풍부한 돼지뼈 국물의 후쿠오카 라멘"),
        Ramen(name: "시오 라멘", flavorScore: 5, baseScore: 5, ingredientScore: 5, description: "깔끔하고 가벼운 소금 국물의 하카타 라멘")
    ]

    // 점수 계산 로직 (가중치 적용)
    func calculateRecommendation() {
        guard let flavor = selectedFlavor, let base = selectedBase, let ingredient = selectedIngredient else { return }

        let flavorScore = scoreForFlavor(flavor)
        let baseScore = scoreForBase(base)
        let ingredientScore = scoreForIngredient(ingredient)

        // 가중치를 적용한 점수 계산
        let totalScore = (flavorScore * 3) + (baseScore * 2) + (ingredientScore * 1)

        recommendedRamen = ramens.max { ramen1, ramen2 in
            let score1 = abs(totalScore - (ramen1.flavorScore * 3 + ramen1.baseScore * 2 + ramen1.ingredientScore * 1))
            let score2 = abs(totalScore - (ramen2.flavorScore * 3 + ramen2.baseScore * 2 + ramen2.ingredientScore * 1))
            return score1 < score2
        }
    }

    // 점수 매핑 (맛, 국물, 재료)
    private func scoreForFlavor(_ flavor: String) -> Int {
        switch flavor {
        case "짠맛": return 8
        case "단맛": return 6
        case "신맛": return 4
        case "매운맛": return 9
        default: return 0
        }
    }

    private func scoreForBase(_ base: String) -> Int {
        switch base {
        case "진함": return 9
        case "연함": return 6
        case "맑음": return 5
        default: return 0
        }
    }

    private func scoreForIngredient(_ ingredient: String) -> Int {
        switch ingredient {
        case "차슈": return 8
        case "숙주": return 7
        case "김": return 6
        case "달걀": return 5
        default: return 0
        }
    }
}
