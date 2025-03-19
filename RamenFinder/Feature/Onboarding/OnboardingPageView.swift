//
//  OnboardingPageView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/30/25.
//

import SwiftUI

// MARK: OnboardingPageView
struct OnboardingPageView: View {
    let item: OnboardingData

    var body: some View {
        VStack(spacing: 20) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()

            Text(item.title)
                .font(.title)
                .fontWeight(.bold)

            Text(item.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}
