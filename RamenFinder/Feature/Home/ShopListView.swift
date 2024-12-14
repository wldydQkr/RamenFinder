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

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                topBar // 커스텀 상단 바
                searchBar // 검색 바

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(filteredShops) { shop in
                            NavigationLink(
                                destination: RamenDetailView(
                                    title: shop.name,
                                    link: shop.link ?? "",
                                    address: shop.address,
                                    roadAddress: shop.roadAddress,
                                    mapX: shop.mapx,
                                    mapY: shop.mapy
                                )
                            ) {
                                ShopRow(shop: shop)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true) // 네비게이션 바 전체 숨기기
        }
        .navigationBarBackButtonHidden(true) // 기본 Back 버튼 숨기기
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
                // 검색 버튼 동작 (추가 구현 가능)
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
            return shops.filter { $0.name.contains(searchText) || $0.roadAddress.contains(searchText) }
        }
    }
}

struct ShopRow: View {
    let shop: RamenShop

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://img1.newsis.com/2022/10/13/NISI20221013_0001105256_web.jpg")) { image in
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
//                    .padding(.bottom)
                
                Text(shop.roadAddress)
                    .font(.subheadline)
                    .foregroundColor(CustomColor.secondary)
                    .frame(alignment: .leading)
                    .lineLimit(1)
                    
                
                Text(shop.address)
                    .font(.subheadline)
                    .foregroundColor(CustomColor.secondary)
                    .lineLimit(1)
                    
            }

            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ShopRow(shop: RamenShop(name: "오레노라멘 합정", roadAddress: "천호대로77가길", address: "장안1동", category: "동대문구", link: "", mapx: 0, mapy: 0))
}
