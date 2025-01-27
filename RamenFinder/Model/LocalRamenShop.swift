//
//  LocalRamenShop.swift
//  RamenFinder
//
//  Created by 박지용 on 1/9/25.
//

import Foundation

struct LocalRamenShop: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let roadAddress: String
    let address: String
    let category: String
    let link: String?
    let mapx: Double
    let mapy: Double

    // Equatable 요구 사항 구현
    static func == (lhs: LocalRamenShop, rhs: LocalRamenShop) -> Bool {
        return lhs.name == rhs.name && lhs.roadAddress == rhs.roadAddress
    }
}
