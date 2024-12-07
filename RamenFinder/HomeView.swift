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

#Preview {
    HomeView()
}
