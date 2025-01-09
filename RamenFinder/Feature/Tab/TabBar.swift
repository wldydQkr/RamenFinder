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
    @Environment(\.managedObjectContext) private var viewContext // Core Data context

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
                    HomeView(context: viewContext) // 전달된 context 사용
                case .map:
                    MapView()
                case .favorites:
                    FavoriteRamenView(container: PersistenceController.shared.container)
                case .profile:
                    HomeView(context: viewContext) // 동일하게 context 전달
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
