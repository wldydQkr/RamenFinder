//
//  RamenSearchResponse.swift
//  RamenFinder
//
//  Created by 박지용 on 1/9/25.
//

import Foundation

struct RamenSearchResponse: Codable {
    let items: [RamenShopResponse]
}
