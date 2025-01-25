//
//  RamenRecommendationView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/25/25.
//

import SwiftUI

struct RamenRecommendationView: View {
    @StateObject private var viewModel = RamenRecommendationViewModel()
    @State private var isNavigating: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("라멘 추천")
                    .font(.largeTitle)
                    .bold()

                // 맛 선택
                VStack {
                    Text("맛을 선택하세요:")
                    HStack {
                        ForEach(["짠맛", "단맛", "신맛", "매운맛"], id: \.self) { flavor in
                            Button(action: {
                                viewModel.selectedFlavor = flavor
                            }) {
                                Text(flavor)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.selectedFlavor == flavor ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }

                // 국물 선택
                VStack {
                    Text("국물을 선택하세요:")
                    HStack {
                        ForEach(["진함", "연함", "맑음"], id: \.self) { base in
                            Button(action: {
                                viewModel.selectedBase = base
                            }) {
                                Text(base)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.selectedBase == base ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }

                // 재료 선택
                VStack {
                    Text("재료를 선택하세요:")
                    HStack {
                        ForEach(["차슈", "숙주", "김", "달걀"], id: \.self) { ingredient in
                            Button(action: {
                                viewModel.selectedIngredient = ingredient
                            }) {
                                Text(ingredient)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.selectedIngredient == ingredient ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }

                // 추천 버튼
                NavigationLink(
                    destination: Group {
                        if let ramen = viewModel.recommendedRamen {
                            RamenRecommendationResultView(ramen: ramen)
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $isNavigating
                ) {
                    Button(action: {
                        viewModel.calculateRecommendation()
                        if viewModel.recommendedRamen != nil {
                            isNavigating = true
                        }
                    }) {
                        Text("라멘 추천 받기")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(viewModel.isSelectionComplete ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!viewModel.isSelectionComplete)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("라멘 추천")
        }
    }
}
