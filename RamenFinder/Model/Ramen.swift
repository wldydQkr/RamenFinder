//
//  Ramen.swift
//  RamenFinder
//
//  Created by 박지용 on 1/25/25.
//

import Foundation

struct Ramen: Identifiable {
    let id = UUID()
    let name: String
    let flavorScore: Int // 짠맛, 단맛 등 맛 점수
    let baseScore: Int   // 국물 베이스 (쇼유, 미소 등)
    let ingredientScore: Int // 재료 점수
    let description: String
}
