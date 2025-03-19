//
//  RamenShop.swift
//  RamenFinder
//
//  Created by 박지용 on 1/9/25.
//

import Foundation

struct RamenShop: Identifiable, Equatable {
    let id = UUID()
    let imageURL: String
    let name: String
    let roadAddress: String
    let address: String
    let category: String
    let link: String?
    let mapx: Double
    let mapy: Double

    // Equatable 요구 사항
    static func == (lhs: RamenShop, rhs: RamenShop) -> Bool {
        return lhs.name == rhs.name && lhs.roadAddress == rhs.roadAddress
    }
}
