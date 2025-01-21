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

    init(container: NSPersistentContainer, homeViewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: FavoriteRamenViewModel(container: container))
        self.homeViewModel = homeViewModel
    }

    var body: some View {
        VStack {
            Text("찜한 매장")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 20)

            ScrollView(showsIndicators: false) {
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
                                viewModel.cacheSelectedShopDetails(shop: shop) // 캐싱된 데이터 사용
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }

            NavigationLink(
                destination: viewModel.selectedShop.map { shop in
                    AnyView(
                        RamenDetailView(
                            title: shop.name ?? "",
                            link: shop.link,
                            address: shop.address ?? "",
                            roadAddress: shop.roadAddress ?? "",
                            mapX: shop.mapx,
                            mapY: shop.mapy,
                            viewModel: homeViewModel
                        )
                    )
                } ?? AnyView(EmptyView()),
                isActive: Binding(
                    get: { viewModel.selectedShop != nil },
                    set: { isActive in
                        if !isActive {
                            viewModel.selectedShop = nil
                        }
                    }
                )
            ) {
                EmptyView()
            }
        }
        .onAppear {
            viewModel.fetchFavorites() // 데이터 초기화
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }

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

//    private let imageUrls = [
//        "https://street-h.com/wp-content/uploads/2023/03/hanroro.jpg",
//        "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2024%2F06%2F11%2Fstreetsnaps-han-roro-13-scaled.jpg?w=1260&cbr=1&q=90&fit=max",
//        "https://cdn.tvj.co.kr/news/photo/202406/97022_235737_1710.jpg",
//        "https://www.halcyonmagazine.kr/bizdemo148322/component/board/board_12/u_image/806/858289651_KakaoTalk_Photo_2024-10-25-10-44-37-1.jpg"
//    ]
    
    private let imageUrls = [
        "https://images.pexels.com/photos/1395319/pexels-photo-1395319.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://live.staticflickr.com/3858/32483361223_2f69a89a43_b.jpg",
        "https://live.staticflickr.com/2870/32420535470_788d045029_b.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/a/a9/돈코츠라멘.jpg"
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
                    .frame(width: cardWidth - 20, height: (cardWidth - 20) * 1.5)
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
                .lineLimit(1)

            Text(shop.roadAddress ?? "Unknown Address")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
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
        .padding(.top, 8)
    }
}
