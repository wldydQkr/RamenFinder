//
//  TabBar.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTab: Tab = .home
    @StateObject private var mapViewModel = MapViewModel()
    @Environment(\.managedObjectContext) private var viewContext // Core Data context

    enum Tab: String, CaseIterable {
        case home = "house.fill"
        case map = "map.fill"
        case favorites = "heart.fill"
        case profile = "person.fill"
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case .home:
                    HomeView(context: viewContext)
                case .map:
                    MapView()
                case .favorites:
                    FavoriteRamenView(container: PersistenceController.shared.container)
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            //MARK: Tab Bar
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 0) {
                            Image(systemName: tab.rawValue)
                                .font(.system(size: 24))
                                .foregroundColor(selectedTab == tab ? CustomColor.primary : .gray)
                                .padding(.top, -8)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
            )
        }
        .edgesIgnoringSafeArea(.bottom) // 하단 안전 영역 제거
        .onAppear {
            mapViewModel.requestInitialLocation()
        }
    }
}

#Preview {
    TabBar()
}
