//
//  RamenShopResponse.swift
//  RamenFinder
//
//  Created by 박지용 on 1/9/25.
//

import Foundation

struct RamenShopResponse: Codable {
    let title: String
    let roadAddress: String
    let address: String
    let category: String
    let link: String
    let mapx: String
    let mapy: String
}
