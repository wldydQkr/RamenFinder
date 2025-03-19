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
    let flavorScore: Int
    let baseScore: Int
    let ingredientScore: Int
    let description: String
}
