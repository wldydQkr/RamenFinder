//
//  SearchView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/8/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var searchViewModel = SearchViewModel()

    var body: some View {
        VStack {
            // 상단 검색창
            HStack {
                TextField("검색어를 입력하세요", text: $searchViewModel.searchText)
                    .padding()
                    .background(CustomColor.background)
                    .cornerRadius(20)
                    .overlay(
                        HStack {
                            Spacer()
                            if !searchViewModel.searchText.isEmpty {
                                Button(action: {
                                    searchViewModel.searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )

                Button(action: {
                    // 실행할 검색 동작
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding()
                        .background(CustomColor.primary)
                        .cornerRadius(999)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            Divider()
                .padding(.vertical)

            // 결과 리스트
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(searchViewModel.searchResults, id: \.id) { shop in
                        RamenShopRowView(shop: shop)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            // 뒤로가기 버튼
            Button(action: {
                dismiss()
            }) {
                Text("뒤로가기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(CustomColor.secondary)
                    .cornerRadius(999)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(CustomColor.background.edgesIgnoringSafeArea(.all))
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct RamenShopRowView: View {
    let shop: RamenShop

    var body: some View {
        HStack(spacing: 16) {
//            Image(systemName: "fork.knife.circle.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 50, height: 50)
//                .foregroundColor(CustomColor.primary)
            Text("🍜")
                .frame(width: 50, height: 50)
                .background(CustomColor.primary)
                .foregroundColor(CustomColor.primary)
                .cornerRadius(999)
            VStack(alignment: .leading, spacing: 4) {
                Text(shop.name)
                    .font(.headline)
                    .fontWeight(.bold)

                Text(shop.roadAddress)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(CustomColor.background)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("찾으시는 매장을 입력하세요", text: $searchText)
                .padding()
                .background(CustomColor.background)
                .cornerRadius(10)

            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding()
                    .background(CustomColor.primary)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    SearchView()
}
