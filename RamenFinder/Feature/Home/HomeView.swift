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
                ScrollView(showsIndicators: false) {
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
                            .foregroundColor(CustomColor.text) // 수정
                            .padding(.trailing)
                    }
                    VStack(alignment: .leading, spacing: 20) {
                        Text("🍜 식당 찾기")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        // 검색창
                        HStack {
                            TextField("찾으시는 라멘집을 입력해주세요.", text: .constant(""))
                                .padding()
                                .background(CustomColor.background) // 수정
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
                            .shadow(color: CustomColor.text.opacity(0.2), radius: 4, x: 0, y: 2) // 수정
                        }

                        // 카테고리
                        Text("지역")
                            .font(.headline)
                            .foregroundColor(CustomColor.text) // 수정
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                CategoryView(icon: "figure.walk", title: "동대문구") {}
                                CategoryView(icon: "mountain.2.fill", title: "성동구") {}
                                CategoryView(icon: "leaf.fill", title: "마포구") {}
                                CategoryView(icon: "building.2.fill", title: "강남구") {}
                                CategoryView(icon: "house.fill", title: "서초구") {}
                            }
                        }

                        // 추천 라멘 섹션
                        HStack {
                            Text("추천 라멘")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(CustomColor.text)

                            Spacer()

                            Button(action: {
                                print("Explore more tapped")
                            }) {
                                Text("더보기 →")
                                    .font(.subheadline)
                                    .foregroundColor(CustomColor.secondary)
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ShopCardView(imageURL: URL(string: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20240529_153%2F1716962503577skV9y_PNG%2FE-label_round_Bib.png"), title: "오레노 라멘", subtitle: "합정동")
                                ShopCardView(imageURL: URL(string: "https://search.pstatic.net/common/?src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyNDEyMDdfMTQx%2FMDAxNzMzNTc5NzQ5NDM5.Rkvpb4U3IoWhG5ddhQQJbOz7rqwO_RVW1cGsIBXZF1wg.UiAP-e08mdUlXa_dZDJ-1scGyPK3JqTJChZy8mfc83Ug.JPEG%2FD7FE5909-00FE-4D9C-8AD4-EBB969DCE7DC.jpeg%3Ftype%3Dw1500_60_sharpen"), title: "오레노 라멘", subtitle: "마포구")
                                ShopCardView(imageURL: URL(string: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20240529_153%2F1716962503577skV9y_PNG%2FE-label_round_Bib.png"), title: "오레노 라멘", subtitle: "연남동")
                            }
                        }

                        // 근처 라멘 섹션
                        HStack {
                            Text("근처 라멘")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(CustomColor.text)

                            Spacer()

                            Button(action: {
                                print("Explore more tapped")
                            }) {
                                Text("더보기 →")
                                    .font(.subheadline)
                                    .foregroundColor(CustomColor.secondary)
                            }
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ShopCardView(imageURL: URL(string: "https://search.pstatic.net/common/?src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyNDEyMDdfMTQx%2FMDAxNzMzNTc5NzQ5NDM5.Rkvpb4U3IoWhG5ddhQQJbOz7rqwO_RVW1cGsIBXZF1wg.UiAP-e08mdUlXa_dZDJ-1scGyPK3JqTJChZy8mfc83Ug.JPEG%2FD7FE5909-00FE-4D9C-8AD4-EBB969DCE7DC.jpeg%3Ftype%3Dw1500_60_sharpen"), title: "오레노 라멘", subtitle: "합정동")
                                ShopCardView(imageURL: URL(string: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20240529_153%2F1716962503577skV9y_PNG%2FE-label_round_Bib.png"), title: "오레노 라멘", subtitle: "마포구")
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
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
