//
//  TabBar.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTab: Tab = .home

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
            // Main Content based on selectedTab
            ZStack {
                switch selectedTab {
                case .home:
                    HomeView()
                case .map:
                    MapView()
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
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 22))
                                .foregroundColor(selectedTab == tab ? CustomColor.background : CustomColor.text)
                            if selectedTab == tab {
                                Text(tab.rawValue)
                                    .font(.footnote)
                                    .foregroundColor(CustomColor.background)
                            }
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: 80)
                        .background(selectedTab == tab ? CustomColor.primary : Color.clear)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(
                CustomColor.background
                    .clipShape(Capsule())
                    .shadow(color: CustomColor.text.opacity(0.1), radius: 5, x: 0, y: -2)
            )
        }
    }
}

//#Preview {
//    TabBar()
//}

//#Preview {
//    TabBar(selectedTab: .constant(.home))
//}
