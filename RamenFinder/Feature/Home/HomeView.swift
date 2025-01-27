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
    @State private var nickname: String = "" // 닉네임 상태 추가
    @State private var profileImage: UIImage? = nil
    @State private var selectedCategoryTitle: String = "동대문구"
    @StateObject private var viewModel: HomeViewModel
    
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
                        
                        // 근처 라멘 섹션
//                            ramenSection(
//                                title: "지역 라멘",
//                                items: viewModel.localRamenShops.map {
//                                    RamenShop(
//                                        imageURL: "https://flexible.img.hani.co.kr/flexible/normal/970/1445/imgdb/original/2024/0618/20240618502333.webp",
//                                        name: $0.name,
//                                        roadAddress: $0.roadAddress,
//                                        address: $0.address,
//                                        category: $0.category ?? "Unknown",
//                                        link: $0.link ?? "",
//                                        mapx: $0.mapx,
//                                        mapy: $0.mapy
//                                    )
//                                }
//                            )
                        
                        // 추천 라멘 섹션
                        ramenSection(
                            title: "추천 라멘",
                            items: viewModel.ramenShops
                        )
                        

                    }
                }
                .onAppear {
                    loadInitialData()
                    loadNickname()
                    validateFetchRequest()
                }
                .navigationBarTitleDisplayMode(.inline)
                .background(
                    NavigationLink(
                        destination: RamenShopListView(
                            title: ramenListTitle,
                            shops: selectedRamenList,
                            viewModel: viewModel
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
    
    // MARK: 지역 카테고리 섹션
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("지역 라멘")
                .font(.headline)
                .foregroundColor(CustomColor.text)
                .padding(.horizontal, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(RegionalCategory.categories) { category in
                        CategoryView(icon: category.icon, title: category.title) {
                            selectedCategoryTitle = category.title // 선택된 카테고리 업데이트
                            viewModel.fetchRamenShopsByCategory(category: category.title)
                            print("Selected: \(category.title)")
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            
            localRamenSection(
                title: "Selected: \(selectedCategoryTitle)", // 선택된 카테고리 표시
                category: selectedCategoryTitle, // 선택된 카테고리 전달
                items: viewModel.localRamenShops
            )
        }
        .padding(.bottom, 0)
    }
    
    // MARK: 근처 라멘 섹션
    private func localRamenSection(title: String, category: String, items: [LocalRamenShop]) -> some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items) { shop in
                        LocalShopCardView(
//                            imageURL: URL(string: "https://flexible.img.hani.co.kr/flexible/normal/970/1445/imgdb/original/2024/0618/20240618502333.jpg"),
                            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/a/a9/돈코츠라멘.jpg"),
                            title: shop.name,
                            subtitle: shop.roadAddress,
                            link: shop.link ?? "https://naver.com",
                            address: shop.address,
                            roadAddress: shop.roadAddress,
                            mapX: shop.mapx,
                            mapY: shop.mapy,
                            selectedCategory: category,
                            viewModel: viewModel
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
    
    // MARK: - 초기 데이터 로드
    private func loadInitialData() {
        if viewModel.ramenShops.isEmpty {
            viewModel.fetchRamenShops(query: "서울 라멘")
        }
        if viewModel.localRamenShops.isEmpty {
            viewModel.fetchRamenShopsByCategory(category: selectedCategoryTitle)
        }
    }
    
    // MARK: - FetchRequest 유효성 검사
    private func validateFetchRequest() {
        guard FavoriteRamen.entity().name != nil else {
            print("Error: FavoriteRamen entity is not properly set.")
            return
        }
        print("FetchRequest is valid.")
    }
    
    private func loadNickname() {
        nickname = UserDefaults.standard.string(forKey: "guestNickname") ?? "Guest"
    }
    
    // MARK: - 상단 인사말 섹션
    private var greetingSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("안녕하세요, \(nickname)님 😊")
                    .font(.title2)
                    .fontWeight(.semibold)
            }

            Spacer()

            if let profileImage = viewModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(CustomColor.background, lineWidth: 1))
                    .shadow(radius: 4)
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                    .foregroundColor(CustomColor.text)
            }
        }
        .padding([.horizontal, .vertical], 8)
        .onAppear {
            viewModel.loadProfileImage()
        }
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
            .padding([.horizontal, .bottom], 8)
            .onTapGesture {
                isSearchViewActive = true
            }
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
                    ramenListTitle = title
                    selectedRamenList = items
                    showRamenListView = true
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
//                            imageURL: URL(string: "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2024%2F06%2F11%2Fstreetsnaps-han-roro-tw.jpg?w=1080&cbr=1&q=90&fit=max"),
                            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/ko/thumb/d/d3/Japan_ramen.JPG/1600px-Japan_ramen.JPG?20090122174202"),
                            title: shop.name,
                            subtitle: shop.roadAddress,
                            link: shop.link ?? "",
                            address: shop.address,
                            roadAddress: shop.roadAddress,
                            mapX: shop.mapx,
                            mapY: shop.mapy,
                            viewModel: viewModel
                        )
                    }
                }
                .padding([.top, .bottom, .horizontal], 8)
            }
        }
    }
}
