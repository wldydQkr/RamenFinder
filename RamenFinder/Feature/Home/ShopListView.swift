//
//  ShopListView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/10/24.
//

import SwiftUI

struct RamenShopListView: View {
    let title: String
    let shops: [RamenShop]

    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    @StateObject private var viewModel: HomeViewModel
    
    // 초기화 메서드 접근 수준 수정
    init(title: String, shops: [RamenShop], viewModel: HomeViewModel) {
        self.title = title
        self.shops = shops
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                topBar
                searchBar

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(filteredShops, id: \.id) { shop in
                            NavigationLink(
                                destination: RamenDetailView(
                                    title: shop.name,
                                    link: shop.link ?? "",
                                    address: shop.address,
                                    roadAddress: shop.roadAddress,
                                    mapX: shop.mapx,
                                    mapY: shop.mapy,
                                    viewModel: viewModel
                                )
                            ) {
                                ShopRow(shop: shop)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationBarBackButtonHidden(true)
    }

    private var topBar: some View {
        ZStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(CustomColor.text)
                        .font(.title3)
                }
                .padding(.leading)

                Spacer()
            }

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(CustomColor.text)
        }
        .frame(height: 60)
        .background(Color.white)
        .overlay(
            Divider(), alignment: .bottom
        )
    }

    private var searchBar: some View {
        HStack {
            TextField("매장 검색", text: $searchText)
                .padding(8)
                .background(CustomColor.background)
                .cornerRadius(8)

            Button(action: {
                // 검색 버튼 동작 (필요 시 추가)
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(CustomColor.text)
                    .padding(8)
                    .background(CustomColor.background)
                    .cornerRadius(8)
            }
        }
        .padding([.horizontal, .top])
    }

    private var filteredShops: [RamenShop] {
        if searchText.isEmpty {
            return shops
        } else {
            return shops.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.roadAddress.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct ShopRow: View {
    let shop: RamenShop

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://live.staticflickr.com/7001/26816760581_f1efc700a2_b.jpg")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)
            .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(shop.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.text)
                    .multilineTextAlignment(.leading)
                
                Text(shop.roadAddress)
                    .font(.subheadline)
                    .foregroundColor(CustomColor.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(shop.address)
                    .font(.subheadline)
                    .foregroundColor(CustomColor.secondary)
                    .lineLimit(1)
                
                Spacer()
            }
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    ShopRow(shop: RamenShop(
        imageURL: "https://example.com/image.jpg",
        name: "오레노라멘 합정",
        roadAddress: "천호대로77가길",
        address: "장안1동",
        category: "동대문구",
        link: "",
        mapx: 0,
        mapy: 0
    ))
}
