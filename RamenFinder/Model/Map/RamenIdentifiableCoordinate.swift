//
//  RamenIdentifiableCoordinate.swift
//  RamenFinder
//
//  Created by 박지용 on 1/30/25.
//

import SwiftUI
import CoreLocation

// 마커 식별을 위한 RamenIdentifiableCoordinate
struct RamenIdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let tint: Color
    let name: String

    init(coordinate: CLLocationCoordinate2D, tint: Color, name: String) {
        self.coordinate = coordinate
        self.tint = tint
        self.name = name
        
        // 경도 값 확인 로그
        print("Creating RamenIdentifiableCoordinate:")
        print("  Name: \(name)")
        print("  Latitude: \(coordinate.latitude)")
        print("  Longitude: \(coordinate.longitude)")
    }
}
