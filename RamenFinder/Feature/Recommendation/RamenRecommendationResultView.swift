//
//  RamenRecommendationResultView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/25/25.
//

import SwiftUI

struct RamenRecommendationResultView: View {
    let ramen: Ramen // 추천받은 라멘

    var body: some View {
        VStack(spacing: 20) {
            Text(ramen.name)
                .font(.largeTitle)
                .bold()

            // 라멘 이미지 (샘플 이미지 URL)
            Image(ramen.name) // 라멘 이름과 이미지 파일 이름을 매칭
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(10)

            Text(ramen.description)
                .font(.body)
                .italic()
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
        .navigationTitle("추천 결과")
        .navigationBarTitleDisplayMode(.inline)
    }
}
