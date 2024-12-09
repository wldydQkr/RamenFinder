//
//  HomeView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: TabBar.Tab = .home
    @State private var isSearchViewActive = false
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        greetingSection
                        searchSection
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
                                    link: "https://naver.com",
                                    latitude: 37.549902,
                                    longitude: 126.913705
                                ),
                                RamenShop(
                                    name: "무메노",
                                    roadAddress: "연남동",
                                    address: "",
                                    category: "",
                                    link: "https://naver.com",
                                    latitude: 37.561632,
                                    longitude: 126.923739
                                )
                            ]
                        )
                    }
                    .padding()
                }
                .onAppear {
                    viewModel.fetchRamenShops(query: "서울 라멘")
                }
                .navigationBarTitleDisplayMode(.inline)
            }

            Spacer()

            TabBar(selectedTab: $selectedTab)
                .padding(.bottom, 20)
        }
        .edgesIgnoringSafeArea(.bottom)
        .fullScreenCover(isPresented: $isSearchViewActive) {
            NavigationView {
                SearchView()
            }
        }
    }

    // 상단 인사말 섹션
    private var greetingSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("안녕하세요, 이형준님😊")
                    .font(.title2)
                    .fontWeight(.semibold)
//                    .padding(.leading)
            }

            Spacer()

            Image(systemName: "person.circle.fill")
                .font(.title)
                .foregroundColor(CustomColor.text)
//                .padding(.trailing)
        }
    }

    // 검색창 섹션
    private var searchSection: some View {
        VStack(alignment: .leading) {
            Text("🍜 식당 찾기")
                .font(.largeTitle)
                .fontWeight(.bold)

            HStack {
                TextField(
                    "찾으시는 라멘집을 입력해주세요.",
                    text: .constant("")
                )
                .padding()
                .background(CustomColor.background)
                .cornerRadius(999)
                .disabled(true)

                Button(action: {
                    isSearchViewActive = true
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
            .onTapGesture {
                isSearchViewActive = true
            }
        }
    }

    // 지역 카테고리 섹션
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

    // 라멘 섹션
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
                    ForEach(items) { shop in
                        ShopCardView(
                            imageURL: URL(string: "https://i.ytimg.com/vi/h-ccx94lXSE/hqdefault.jpg?sqp=-oaymwEjCNACELwBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDuCs5orHjNXdXnBLARfzedQTwMEA"),
                            title: shop.name,
                            subtitle: shop.roadAddress,
                            link: shop.link ?? "https://naver.com",
                            address: shop.address,
                            roadAddress: shop.roadAddress,
                            mapX: shop.longitude,
                            mapY: shop.latitude
                        )
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .frame(width: 150, height: 100)
                    }
                }
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
                    .frame(height: 15)
                    .fixedSize(horizontal: true, vertical: false)

                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(height: 15)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(CustomColor.primary)
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
    let link: String
    let address: String
    let roadAddress: String
    let mapX: Double
    let mapY: Double
    
    @State private var isLiked: Bool = false

    var body: some View {
        NavigationLink(destination: RamenDetailView(
            title: title,
            link: link,
            address: address,
            roadAddress: roadAddress,
            mapX: mapX,
            mapY: mapY
        )) {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomTrailing) {
                    if let imageURL = imageURL {
                        AsyncImage(url: imageURL) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 100)
                                .cornerRadius(10)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 150, height: 100)
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 100)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .clipped()
                    }

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

                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(width: 150)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
}
