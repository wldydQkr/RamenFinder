//
//  MapView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/14/24.
//

import SwiftUI
import MapKit

struct ContainerView: View {
    @StateObject var viewModel: MapViewModel
    @StateObject private var locationManager = LocationManager()
    @State private var region: MKCoordinateRegion?

    var ramenShop: NearbyRamenShop

    init(viewModel: MapViewModel, ramenShop: NearbyRamenShop) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.ramenShop = ramenShop
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: ramenShop.mapy, longitude: ramenShop.mapx),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        VStack {
            Text(ramenShop.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding()

            MapView(region: $region, ramenShop: ramenShop, locationManager: locationManager)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
        .onAppear {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: ramenShop.mapy, longitude: ramenShop.mapx),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
}

struct MapView: View {
    @Binding var region: MKCoordinateRegion?
    let ramenShop: NearbyRamenShop
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        if let region = region {
            let shopCoordinate = CLLocationCoordinate2D(latitude: ramenShop.mapy, longitude: ramenShop.mapx)
            let annotationItems = [IdentifiableCoordinate(coordinate: shopCoordinate, tint: .red)]

            Map(coordinateRegion: .constant(region), annotationItems: annotationItems) { item in
                MapMarker(coordinate: item.coordinate, tint: item.tint)
            }
            .frame(height: 300)
            .cornerRadius(10)
            .padding(.horizontal)
        } else {
            Text("Loading map...")
        }
    }

    struct IdentifiableCoordinate: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
        let tint: Color
    }
}

//#Preview {
//    MapView()
//}
