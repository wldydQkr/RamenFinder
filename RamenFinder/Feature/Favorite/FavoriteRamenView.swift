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

    // ViewModel을 주입하기 위한 초기화 메서드
    init(container: NSPersistentContainer) {
        _viewModel = StateObject(wrappedValue: FavoriteRamenViewModel(container: container))
    }

    @State private var selectedShop: FavoriteRamen? // 선택된 매장을 저장
    @State private var isDetailViewActive = false // DetailView로 이동 상태 관리

    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                VStack(spacing: 0) {
                    //MARK: 헤더 섹션
                    Text("찜한 매장")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    //MARK: 즐겨찾기 라멘 리스트
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.favoriteRamenShops, id: \.self) { shop in
                                Button(action: {
                                    selectedShop = shop
                                    isDetailViewActive = true
                                }) {
                                    FavoriteRamenCardView(
                                        shop: shop,
                                        onDelete: { shopToDelete in
                                            viewModel.removeFavorite(shop: shopToDelete) // 삭제 동작 실행
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }

                    //MARK: NavigationLink로 RamenDetailView로 이동
                    NavigationLink(
                        destination: RamenDetailView(
                            title: selectedShop?.name ?? "Unknown",
                            link: selectedShop?.link,
                            address: selectedShop?.address ?? "Unknown",
                            roadAddress: selectedShop?.roadAddress ?? "Unknown",
                            mapX: selectedShop?.mapx ?? 0,
                            mapY: selectedShop?.mapy ?? 0
                        ),
                        isActive: $isDetailViewActive
                    ) {
                        EmptyView()
                    }
                }
                .navigationBarHidden(true)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct FavoriteRamenCardView: View {
    let shop: FavoriteRamen
    let onDelete: (FavoriteRamen) -> Void // 삭제 동작을 전달받는 클로저

    @State private var showDeleteConfirmation = false // 삭제 확인 다이얼로그 상태

    var body: some View {
        HStack(spacing: 16) {
            // 원형 이미지 자리
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(shop.name?.prefix(1) ?? "❤️") // 매장 이름의 첫 글자 표시
                        .font(.title)
                        .foregroundColor(.white)
                )

            // 텍스트 상세 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(shop.name ?? "Unknown") // 매장 이름
                    .font(.headline)
                    .lineLimit(1)

                Text(shop.roadAddress ?? "Unknown Address") // 매장 도로명 주소
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            //MARK: Delete Button
            Button(action: {
                showDeleteConfirmation = true // 삭제 확인 다이얼로그 표시
            }) {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .confirmationDialog("이 매장을 삭제하시겠습니까?", isPresented: $showDeleteConfirmation, actions: {
                Button("삭제", role: .destructive) {
                    onDelete(shop)
                }
                Button("취소", role: .cancel) {}
            })
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
