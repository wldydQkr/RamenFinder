//
//  CategoryView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/10/24.
//

import SwiftUI

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
                    .frame(height: 15)
                    .fixedSize(horizontal: true, vertical: false)

                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(height: 15)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(CustomColor.primary)
            .cornerRadius(999)
        }
        .padding(.bottom, 5)
        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
//    CategoryView()
//}
