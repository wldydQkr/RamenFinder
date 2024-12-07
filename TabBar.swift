//
//  TabBar.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

//import SwiftUI
//
//struct TabBar: View {
//    @Binding var selectedTab: Tab
//
//    enum Tab: String, CaseIterable {
//        case home = "Home"
//        case games = "Games"
//        case library = "Library"
//        case videos = "Videos"
//
//        var icon: String {
//            switch self {
//            case .home: return "house.fill"
//            case .games: return "gamecontroller.fill"
//            case .library: return "square.stack.fill"
//            case .videos: return "play.tv.fill"
//            }
//        }
//    }
//
//    var body: some View {
//        HStack {
//            ForEach(Tab.allCases, id: \.self) { tab in
//                Button(action: {
//                    withAnimation {
//                        selectedTab = tab
//                    }
//                }) {
//                    HStack {
//                        Image(systemName: tab.icon)
//                            .font(.system(size: 20))
//                            .foregroundColor(selectedTab == tab ? .white : .gray)
//                        if selectedTab == tab {
//                            Text(tab.rawValue)
//                                .font(.system(size: 14, weight: .semibold))
//                                .foregroundColor(.white)
//                        }
//                    }
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, selectedTab == tab ? 16 : 0)
//                    .background(selectedTab == tab ? Color.purple : Color.clear)
//                    .clipShape(Capsule())
//                }
//                .frame(maxWidth: .infinity)
//            }
//        }
//        .padding()
//        .background(
//            Color.white
//                .clipShape(Capsule())
//                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
//        )
//        .padding(.horizontal)
//    }
//}
//
//#Preview {
//    TabBar(selectedTab: <#Binding<TabBar.Tab>#>)
//}
