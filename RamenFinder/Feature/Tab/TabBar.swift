//
//  TabBar.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI
import CoreLocation

struct TabBar: View {
    @State private var selectedTab: Tab = .home
    @StateObject private var mapViewModel = MapViewModel()

    enum Tab: String, CaseIterable {
        case home = "Home"
        case map = "Map"
        case favorites = "Favorites"
        case profile = "Profile"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .map: return "map.fill"
            case .favorites: return "heart.fill"
            case .profile: return "person.fill"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case .home:
                    HomeView()
                case .map:
                    // MapViewModel을 활용하여 라멘 매장 데이터를 표시
                    if mapViewModel.ramenShops.isEmpty {
                        Text("Fetching nearby ramen shops...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .onAppear {
                                mapViewModel.requestInitialLocation()
                            }
                    } else {
                        // 첫 번째 라멘 매장 정보를 ContainerView로 전달
                        if let firstShop = mapViewModel.ramenShops.first {
                            ContainerView(viewModel: mapViewModel, ramenShop: firstShop)
                        } else {
                            Text("No shops available")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    }
                case .favorites:
                    HomeView()
                case .profile:
                    HomeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Tab Bar
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation {
                            selectedTab = tab
                        }
                    }) {
                        VStack {
                            Image(systemName: tab.icon)
                                .font(.system(size: 22))
                                .foregroundColor(selectedTab == tab ? Color.blue : Color.gray)
                            if selectedTab == tab {
                                Text(tab.rawValue)
                                    .font(.footnote)
                                    .foregroundColor(Color.blue)
                            }
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: 80)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
        .onAppear {
            // 라멘 매장 데이터를 요청
            mapViewModel.requestInitialLocation()
        }
    }
}

#Preview {
    TabBar()
}

//#Preview {
//    TabBar(selectedTab: .constant(.home))
//}
