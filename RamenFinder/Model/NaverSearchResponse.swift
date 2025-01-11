//
//  NaverSearchResponse.swift
//  RamenFinder
//
//  Created by 박지용 on 1/7/25.
//

import Foundation

// 네이버 API 응답 모델
struct NaverSearchResponse: Codable {
    let items: [ShopItem]
}
