//
//  FavoriteRamenView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/7/25.
//

import SwiftUI
import CoreData

struct FavoriteRamenView: View {
    @StateObject private var viewModel: FavoriteRamenViewModel
    @ObservedObject var homeViewModel: HomeViewModel

    // MARK: - Initializer
    init(container: NSPersistentContainer, homeViewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: FavoriteRamenViewModel(container: container))
        self.homeViewModel = homeViewModel
    }

    @State private var selectedShop: FavoriteRamen? // 선택된 매장
    @State private var isDetailViewActive = false // DetailView로 이동 상태

    var body: some View {
        VStack {
            Text("찜한 매장")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 20)

            ScrollView {
                MasonryVStack(columns: 2, spacing: 16) {
                    ForEach(viewModel.favoriteRamenShops, id: \.self) { shop in
                        FavoriteRamenCardView(
                            shop: shop,
                            onDelete: { shopToDelete in
                                viewModel.removeFavorite(shop: shopToDelete)
                            },
                            homeViewModel: homeViewModel,
                            onCardTap: {
                                selectedShop = shop
                                isDetailViewActive = true
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }

            // MARK: NavigationLink로 DetailView 연결
            NavigationLink(
                destination: RamenDetailView(
                    title: selectedShop?.name ?? "",
                    link: selectedShop?.link,
                    address: selectedShop?.address ?? "",
                    roadAddress: selectedShop?.roadAddress ?? "",
                    mapX: selectedShop?.mapx ?? 0,
                    mapY: selectedShop?.mapy ?? 0,
                    viewModel: homeViewModel
                ),
                isActive: $isDetailViewActive
            ) {
                EmptyView()
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct FavoriteRamenCardView: View {
    let shop: FavoriteRamen
    let onDelete: (FavoriteRamen) -> Void
    @ObservedObject var homeViewModel: HomeViewModel
    let onCardTap: () -> Void

    @State private var showDeleteConfirmation = false
    @State private var randomImageURL: String // 랜덤 이미지 URL 상태

    // 이미지 URL 리스트
    private let imageUrls = [
        "https://street-h.com/wp-content/uploads/2023/03/hanroro.jpg",
        "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2024%2F06%2F11%2Fstreetsnaps-han-roro-13-scaled.jpg?w=1260&cbr=1&q=90&fit=max",
        "https://cdn.tvj.co.kr/news/photo/202406/97022_235737_1710.jpg"
    ]

    init(
        shop: FavoriteRamen,
        onDelete: @escaping (FavoriteRamen) -> Void,
        homeViewModel: HomeViewModel,
        onCardTap: @escaping () -> Void
    ) {
        self.shop = shop
        self.onDelete = onDelete
        self.homeViewModel = homeViewModel
        self.onCardTap = onCardTap
        self._randomImageURL = State(initialValue: imageUrls.randomElement()!) // 초기화 시 랜덤 선택
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FavoriteRamenImageSection(
                randomImageURL: randomImageURL,
                onCardTap: onCardTap
            )

            FavoriteRamenInfoSection(
                shop: shop,
                onDelete: onDelete,
                showDeleteConfirmation: $showDeleteConfirmation
            )
        }
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct FavoriteRamenImageSection: View {
    let randomImageURL: String
    let onCardTap: () -> Void

    var body: some View {
        Button(action: onCardTap) {
            AsyncImage(url: URL(string: randomImageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .cornerRadius(12)
                    .clipped()
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 150)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FavoriteRamenInfoSection: View {
    let shop: FavoriteRamen
    let onDelete: (FavoriteRamen) -> Void
    @Binding var showDeleteConfirmation: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 가게 이름과 주소
            Text(shop.name ?? "Unknown")
                .font(.headline)
                .lineLimit(2)

            Text(shop.roadAddress ?? "Unknown Address")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)

            // 삭제 버튼
            HStack {
                Spacer()
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                        .padding(8)
                }
                .confirmationDialog("이 매장을 삭제하시겠습니까?", isPresented: $showDeleteConfirmation) {
                    Button("삭제", role: .destructive) {
                        onDelete(shop)
                    }
                    Button("취소", role: .cancel) {}
                }
            }
        }
        .padding([.horizontal, .bottom], 8)
    }
}
