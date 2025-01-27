//
//  RegionalCategory.swift
//  RamenFinder
//
//  Created by 박지용 on 12/14/24.
//

import SwiftUI

struct RegionalCategory: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    
    static let categories: [RegionalCategory] = [
        RegionalCategory(icon: "figure.walk", title: "동대문구"),
        RegionalCategory(icon: "building.2.fill", title: "중구"),
        RegionalCategory(icon: "train.side.front.car", title: "용산구"),
        RegionalCategory(icon: "mountain.2.fill", title: "성동구"),
        RegionalCategory(icon: "leaf.fill", title: "광진구"),
        RegionalCategory(icon: "figure.walk", title: "종로구"),
        RegionalCategory(icon: "house.fill", title: "중랑구"),
        RegionalCategory(icon: "building.2.fill", title: "성북구"),
        RegionalCategory(icon: "cloud.fill", title: "강북구"),
        RegionalCategory(icon: "sun.max.fill", title: "도봉구"),
        RegionalCategory(icon: "figure.walk", title: "노원구"),
        RegionalCategory(icon: "building.2.fill", title: "은평구"),
        RegionalCategory(icon: "leaf.fill", title: "서대문구"),
        RegionalCategory(icon: "cloud.fill", title: "마포구"),
        RegionalCategory(icon: "sun.max.fill", title: "양천구"),
        RegionalCategory(icon: "figure.walk", title: "강서구"),
        RegionalCategory(icon: "house.fill", title: "구로구"),
        RegionalCategory(icon: "building.2.fill", title: "금천구"),
        RegionalCategory(icon: "leaf.fill", title: "영등포구"),
        RegionalCategory(icon: "sun.max.fill", title: "동작구"),
        RegionalCategory(icon: "figure.walk", title: "관악구"),
        RegionalCategory(icon: "building.2.fill", title: "서초구"),
        RegionalCategory(icon: "cloud.fill", title: "강남구"),
        RegionalCategory(icon: "leaf.fill", title: "송파구"),
        RegionalCategory(icon: "sun.max.fill", title: "강동구")
    ]
}
