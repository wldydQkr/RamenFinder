//
//  HomeView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: TabBar.Tab = .home
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // 상단 인사말 섹션
                        greetingSection

                        // 검색창
                        searchSection

                        // 지역 카테고리 섹션
                        categorySection

                        // 추천 라멘 섹션
                        ramenSection(
                            title: "추천 라멘",
                            items: viewModel.ramenShops
                        )

                        // 근처 라멘 섹션
                        ramenSection(
                            title: "근처 라멘",
                            items: [
                                RamenShop(
                                    name: "오레노 라멘",
                                    roadAddress: "합정동",
                                    address: "",
                                    category: "",
                                    latitude: 0,
                                    longitude: 0
                                ),
                                RamenShop(
                                    name: "무메노",
                                    roadAddress: "연남동",
                                    address: "",
                                    category: "",
                                    latitude: 0,
                                    longitude: 0
                                )
                            ]
                        )
                    }
                    .padding()
                }
                .onAppear {
                    print("onAppear 호출됨.")
                    viewModel.fetchRamenShops()
                }
                .navigationBarTitleDisplayMode(.inline)
            }

            Spacer()

            TabBar(selectedTab: $selectedTab)
                .padding(.bottom, 20)
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    // Greeting Section
    private var greetingSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("안녕하세요, 홍길동님")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.leading)
            }
            
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .font(.title)
                .foregroundColor(CustomColor.text)
                .padding(.trailing)
        }
    }

    // Search Section
    private var searchSection: some View {
        VStack(alignment: .leading) {
            Text("🍜 식당 찾기")
                .font(.largeTitle)
                .fontWeight(.bold)

            HStack {
                TextField("찾으시는 라멘집을 입력해주세요.", text: .constant(""))
                    .padding()
                    .background(CustomColor.background)
                    .cornerRadius(999)
                
                Button(action: {
                    print("Search button tapped")
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .background(CustomColor.primary)
                        .cornerRadius(999)
                }
                .shadow(color: CustomColor.text.opacity(0.2), radius: 4, x: 0, y: 2)
            }
        }
    }

    // Category Section
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("지역")
                .font(.headline)
                .foregroundColor(CustomColor.text)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    CategoryView(icon: "figure.walk", title: "동대문구") {}
                    CategoryView(icon: "mountain.2.fill", title: "성동구") {}
                    CategoryView(icon: "leaf.fill", title: "마포구") {}
                    CategoryView(icon: "building.2.fill", title: "강남구") {}
                    CategoryView(icon: "house.fill", title: "서초구") {}
                }
            }
        }
    }

    // Ramen Section
    private func ramenSection(title: String, items: [RamenShop]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(CustomColor.text)

                Spacer()

                Button(action: {
                    print("\(title) 더보기 클릭")
                }) {
                    Text("더보기 →")
                        .font(.subheadline)
                        .foregroundColor(CustomColor.secondary)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.ramenShops) { shop in
                        ShopCardView(
                            imageURL: URL(string: "https://i.ytimg.com/vi/Ngrety1u_Tk/hqdefault.jpg?sqp=-oaymwEjCNACELwBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDoV99texdogOwObr3Elyyt8L9xCA"),
                            title: shop.name,
                            subtitle: shop.roadAddress
                        )
                        .onAppear {
                            if shop == viewModel.ramenShops.last && !viewModel.isLoading {
                                viewModel.fetchRamenShops(isNextPage: true)
                            }
                        }
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .frame(width: 150, height: 100)
                    }
                }
//                .padding(.horizontal)
            }
        }
    }
}
struct CategoryView: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(height: 25)
                    .fixedSize(horizontal: true, vertical: false)

                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(height: 25)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(CustomColor.primary) // 수정
            .cornerRadius(999)
        }
        .padding(.bottom, 5)
        .buttonStyle(PlainButtonStyle())
    }
}

struct ShopCardView: View {
    let imageURL: URL?
    let title: String
    let subtitle: String
    @State private var isLiked: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
                if let imageURL = imageURL {
                    // AsyncImage for loading image from URL
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            // Placeholder while loading
                            ProgressView()
                                .frame(width: 150, height: 100)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        case .success(let image):
                            // Loaded successfully
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 100)
                                .cornerRadius(10)
                                .clipped()
                        case .failure:
                            // Error loading image
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 100)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .clipped()
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    // Fallback for nil URL
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 100)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .clipped()
                }

                // 좋아요 버튼
                Button(action: {
                    isLiked.toggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isLiked ? .pink : .white)
                        .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
                        .padding(8)
                }
            }

            // 텍스트
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(CustomColor.text) // 수정
        }
        .frame(width: 150)
    }
}

#Preview {
    HomeView()
}
