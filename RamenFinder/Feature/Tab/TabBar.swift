//
//  TabBar.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Tab

    enum Tab: String, CaseIterable {
        case home = "Home"
        case favorites = "Favorites"
        case trips = "Trips"
        case profile = "Profile"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .favorites: return "heart.fill"
            case .trips: return "bag.fill"
            case .profile: return "person.fill"
            }
        }
    }

    var body: some View {
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
                            .foregroundColor(selectedTab == tab ? CustomColor.background : CustomColor.text) // 수정
                        if selectedTab == tab {
                            Text(tab.rawValue)
                                .font(.footnote)
                                .foregroundColor(CustomColor.background) // 수정
                        }
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: 80)
                    .background(selectedTab == tab ? CustomColor.primary : Color.clear) // 수정
                    .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(
            CustomColor.background // 수정
                .clipShape(Capsule())
                .shadow(color: CustomColor.text.opacity(0.1), radius: 5, x: 0, y: -2) // 수정
        )
    }
}

//#Preview {
//    TabBar(selectedTab: .constant(.home))
//}
