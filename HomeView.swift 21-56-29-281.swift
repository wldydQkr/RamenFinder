//
//  HomeView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: TabBar.Tab = .home

    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Where do you want to go?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        // 검색창
                        HStack {
                            TextField("Search for places...", text: .constant(""))
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            
                            Button(action: {
                                print("Search button tapped")
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.teal)
                                    .cornerRadius(10)
                            }
                        }

                        // 카테고리
                        Text("Categories")
                            .font(.headline)
                        
                        HStack(spacing: 16) {
                            CategoryView(icon: "figure.walk", title: "Camp")
                            CategoryView(icon: "mountain.2.fill", title: "Mountains")
                            CategoryView(icon: "leaf.fill", title: "Nature")
                        }

                        // 추천 여행 섹션
                        HStack {
                            Text("Top trips")
                                .font(.headline)
                                .fontWeight(.semibold)

                            Spacer()

                            Button(action: {
                                print("Explore more tapped")
                            }) {
                                Text("Explore →")
                                    .font(.subheadline)
                                    .foregroundColor(.teal)
                            }
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                TripCard(imageName: "example1", title: "Banjir Kanal", subtitle: "Camp")
                                TripCard(imageName: "example2", title: "Jatibarang", subtitle: "Lake")
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        VStack(alignment: .leading) {
                            Text("Hi, Jennifer!")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }

            Spacer()

            TabBar(selectedTab: $selectedTab)
                .padding(.bottom, 20)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CategoryView: View {
    let icon: String
    let title: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.teal)
                .clipShape(Circle())
            
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        }
    }
}

struct TripCard: View {
    let imageName: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 100)
                .cornerRadius(10)
                .clipped()

            Text(title)
                .font(.headline)
                .fontWeight(.semibold)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 150)
    }
}

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
                            .foregroundColor(selectedTab == tab ? .white : .gray)
                        if selectedTab == tab {
                            Text(tab.rawValue)
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: 80)
                    .background(selectedTab == tab ? Color.teal : Color.clear)
                    .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(
            Color.white
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
        )
    }
}

#Preview {
    HomeView()
}
