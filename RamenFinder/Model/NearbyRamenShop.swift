//
//  NearbyRamenShop.swift
//  RamenFinder
//
//  Created by 박지용 on 1/7/25.
//

import Foundation

struct NearbyRamenShop: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let roadAddress: String
    let address: String
    let category: String
    let link: String?
    let mapx: Double
    let mapy: Double

    enum CodingKeys: String, CodingKey {
        case name = "title"
        case roadAddress
        case address
        case category
        case link
        case mapx
        case mapy
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let rawName = try container.decode(String.self, forKey: .name)
        name = rawName.stripHTML()
        
        roadAddress = try container.decode(String.self, forKey: .roadAddress)
        address = try container.decode(String.self, forKey: .address)
        category = try container.decode(String.self, forKey: .category)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        
        // 좌표값 처리
        if let mapxString = try? container.decode(String.self, forKey: .mapx),
           let mapyString = try? container.decode(String.self, forKey: .mapy),
           let mapxValue = Double(mapxString),
           let mapyValue = Double(mapyString) {
            mapx = mapxValue / 1_000_000.0
            mapy = mapyValue / 1_000_000.0
        } else {
            throw DecodingError.dataCorruptedError(forKey: .mapx, in: container, debugDescription: "Invalid mapx or mapy value")
        }
    }
}
