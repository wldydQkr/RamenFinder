//
//  FavoriteRamenView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/7/25.
//

import SwiftUI
import CoreData

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

    @State private var selectedShop: FavoriteRamen?
    @State private var isDetailViewActive = false

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
                            cardWidth: calculateCardWidth(),
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

            //MARK: NavigationLink로 DetailView 연결
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

    // MARK: - Helper Function
    private func calculateCardWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing: CGFloat = 16 * (2 - 1)
        return (screenWidth - totalSpacing) / 2
    }
}

struct FavoriteRamenCardView: View {
    let shop: FavoriteRamen
    let cardWidth: CGFloat
    let onDelete: (FavoriteRamen) -> Void
    @ObservedObject var homeViewModel: HomeViewModel
    let onCardTap: () -> Void

    @State private var showDeleteConfirmation = false
    @State private var randomImageURL: String

    private let imageUrls = [
        "https://street-h.com/wp-content/uploads/2023/03/hanroro.jpg",
        "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2024%2F06%2F11%2Fstreetsnaps-han-roro-13-scaled.jpg?w=1260&cbr=1&q=90&fit=max",
        "https://cdn.tvj.co.kr/news/photo/202406/97022_235737_1710.jpg"
    ]

    init(
        shop: FavoriteRamen,
        cardWidth: CGFloat,
        onDelete: @escaping (FavoriteRamen) -> Void,
        homeViewModel: HomeViewModel,
        onCardTap: @escaping () -> Void
    ) {
        self.shop = shop
        self.cardWidth = cardWidth
        self.onDelete = onDelete
        self.homeViewModel = homeViewModel
        self.onCardTap = onCardTap
        self._randomImageURL = State(initialValue: imageUrls.randomElement()!)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FavoriteRamenImageSection(
                randomImageURL: randomImageURL,
                cardWidth: cardWidth,
                onCardTap: onCardTap
            )

            FavoriteRamenInfoSection(
                shop: shop,
                onDelete: onDelete,
                showDeleteConfirmation: $showDeleteConfirmation
            )
        }
        .frame(width: cardWidth)
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct FavoriteRamenImageSection: View {
    let randomImageURL: String
    let cardWidth: CGFloat
    let onCardTap: () -> Void

    var body: some View {
        Button(action: onCardTap) {
            AsyncImage(url: URL(string: randomImageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardWidth - 15)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: cardWidth - 20, height: (cardWidth - 20) * 1.5) // 비율 유지
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
                .padding(.trailing, 16)

            // 삭제 버튼
            HStack {
                Spacer()
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                        .padding(16)
                }
                .confirmationDialog("이 매장을 삭제하시겠습니까?", isPresented: $showDeleteConfirmation) {
                    Button("삭제", role: .destructive) {
                        onDelete(shop)
                    }
                    Button("취소", role: .cancel) {}
                }
            }
        }
        .padding([.vertical], 8)
    }
}
