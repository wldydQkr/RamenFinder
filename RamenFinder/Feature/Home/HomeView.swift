//
//  HomeView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @State private var selectedTab: TabBar.Tab = .home
    @State private var isSearchViewActive = false
    @StateObject private var viewModel: HomeViewModel
    private let hPadding: Int = 8
    
    // FetchRequest로 Core Data 데이터 관리
    @FetchRequest(
        entity: FavoriteRamen.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteRamen.name, ascending: true)]
    ) private var favoriteRamenShops: FetchedResults<FavoriteRamen>
    
    // 전체 매장 리스트로 이동하기 위한 State
    @State private var selectedRamenList: [RamenShop] = []
    @State private var selectedLocalRamenList: [LocalRamenShop] = []
    @State private var ramenListTitle: String = ""
    @State private var showRamenListView = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - Initializer
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(context: context))
    }
    
    var body: some View {
        VStack {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
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
                                    address: "서울특별시 동대문구 장안1동 406-2",
                                    category: "서울특별시 천호대로 77가길 18",
                                    link: "https://naver.com",
                                    mapx: 0,
                                    mapy: 0
                                ),
                                RamenShop(
                                    name: "무메노",
                                    roadAddress: "연남동",
                                    address: "서울특별시 동대문구 장안1동 406-2",
                                    category: "서울특별시 천호대로 77가길 18",
                                    link: "https://naver.com",
                                    mapx: 0,
                                    mapy: 0
                                )
                            ]
                        )
                    }
                }
                .onAppear {
                    loadInitialData()
                    validateFetchRequest()
                }
                .navigationBarTitleDisplayMode(.inline)
                .background(
                    NavigationLink(
                        destination: RamenShopListView(
                            title: ramenListTitle,
                            shops: selectedRamenList
                        ),
                        isActive: $showRamenListView
                    ) {
                        EmptyView()
                    }
                )
            }
            
            Spacer()
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .fullScreenCover(isPresented: $isSearchViewActive) {
            NavigationView {
                SearchView()
            }
        }
    }
    
    // MARK: - 초기 데이터 로드
    private func loadInitialData() {
        // 중복 호출 방지
        if viewModel.ramenShops.isEmpty {
            viewModel.fetchRamenShops(query: "서울 라멘")
        }
        if viewModel.localRamenShops.isEmpty {
            viewModel.fetchRamenShopsByCategory(category: "동대문구")
        }
    }
    
    // MARK: - FetchRequest 유효성 검사
    private func validateFetchRequest() {
        // FetchRequest의 entity가 제대로 설정되어 있는지 확인
        guard FavoriteRamen.entity().name != nil else {
            print("Error: FavoriteRamen entity is not properly set.")
            return
        }
        print("FetchRequest is valid.")
    }
    
    // MARK: - 상단 인사말 섹션
    private var greetingSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("안녕하세요, 이형준님😊")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .font(.title)
                .foregroundColor(CustomColor.text)
        }
        .padding(.horizontal, 8)
    }
    
    // MARK: - 검색창 섹션
    private var searchSection: some View {
        VStack(alignment: .leading) {
            Text("🍜 식당 찾기")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal, 8)
            
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
            .padding(.horizontal, 8)
            .onTapGesture {
                isSearchViewActive = true
            }
        }
    }
    
    // MARK: 지역 카테고리 섹션
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("지역")
                .font(.headline)
                .foregroundColor(CustomColor.text)
                .padding(.horizontal, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(RegionalCategory.categories) { category in
                        CategoryView(icon: category.icon, title: category.title) {
                            viewModel.fetchRamenShopsByCategory(category: category.title)
                            print("Selected: \(category.title)")
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            
            // 지역 라멘 섹션
            localRamenSection(
                title: ramenListTitle,
                items: viewModel.localRamenShops
            )
        }
        .padding(.bottom, 0) // 섹션과의 간격을 제거
    }
    
    // MARK: 근처 라멘 섹션
    private func localRamenSection(title: String, items: [LocalRamenShop]) -> some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items) { shop in
                        LocalShopCardView(
                            imageURL: URL(string: "https://i.ytimg.com/vi/Ngrety1u_Tk/hqdefault.jpg?sqp=-oaymwEjCNACELwBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDoV99texdogOwObr3Elyyt8L9xCA"),
                            title: shop.name,
                            subtitle: shop.roadAddress,
                            link: shop.link ?? "https://naver.com",
                            address: shop.address,
                            roadAddress: shop.roadAddress,
                            mapX: shop.mapx,
                            mapY: shop.mapy
                        )
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(width: 150, height: 100)
                    }
                }
                .padding([.top, .bottom, .horizontal], 8)
            }
    }
    
    // MARK: - 추천 라멘 섹션
    private func ramenSection(title: String, items: [RamenShop]) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(CustomColor.text)
                
                Spacer()
                
                Button(action: {
                    print("\(title) 더보기 클릭")
                    self.ramenListTitle = title
                    self.selectedRamenList = items
                    self.showRamenListView = true
                }) {
                    Text("더보기 →")
                        .font(.subheadline)
                        .foregroundColor(CustomColor.secondary)
                }
            }
            .padding(.horizontal, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items) { shop in
                        ShopCardView(
                            imageURL: URL(string: "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2024%2F06%2F11%2Fstreetsnaps-han-roro-tw.jpg?w=1080&cbr=1&q=90&fit=max"),
                            title: shop.name,
                            subtitle: shop.roadAddress,
                            link: shop.link ?? "https://naver.com",
                            address: shop.address,
                            roadAddress: shop.roadAddress,
                            mapX: shop.mapx,
                            mapY: shop.mapy
                        )
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(width: 150, height: 100)
                    }
                }
                .padding([.top, .bottom, .horizontal], 8)
            }
        }
//        .padding(.leading, 10)
    }
    
    // MARK: - 즐겨찾기 섹션
    private var favoriteRamenSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("즐겨찾기")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(CustomColor.text)
            
            if favoriteRamenShops.isEmpty {
                Text("아직 즐겨찾기가 없습니다.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            } else {
                ForEach(favoriteRamenShops, id: \.self) { shop in
                    HStack {
                        Text(shop.name ?? "Unknown")
                            .font(.subheadline)
                        Spacer()
                        Button(action: {
                            deleteFavorite(shop: shop)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 즐겨찾기 삭제
    private func deleteFavorite(shop: FavoriteRamen) {
        viewContext.delete(shop)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete favorite: \(error.localizedDescription)")
        }
    }
}
