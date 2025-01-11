//
//  LocalShopCardView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/11/24.
//

import SwiftUI

struct LocalShopCardView: View {
    let imageURL: URL?
    let title: String
    let subtitle: String
    let link: String
    let address: String
    let roadAddress: String
    let mapX: Double
    let mapY: Double

    @State private var isBookmarked: Bool = false

    var body: some View {
        NavigationLink(destination: RamenDetailView(
            title: title,
            link: link,
            address: address,
            roadAddress: roadAddress,
            mapX: mapX,
            mapY: mapY
        )) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    if let imageURL = imageURL {
                        AsyncImage(url: imageURL) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 100)
                                .cornerRadius(7)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 150, height: 100)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 100)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(7)
                            .clipped()
                    }

//                    Text(title)
//                        .font(.caption)
//                        .fontWeight(.semibold)
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                        .background(Color.black.opacity(0.6))
//                        .foregroundColor(.white)
//                        .cornerRadius(5)
//                        .padding(8)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding([.horizontal], 8)
                    .padding(.top, 4)
//                    .padding(.bottom, 4)
//                    .background(Color.black.opacity(0.6))
                    .foregroundColor(.black)
                    .cornerRadius(5)


                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                    .lineLimit(2)

                HStack {
//                    Spacer()
                    Button(action: {
                        isBookmarked.toggle()
                    }) {
                        Image(systemName: isBookmarked ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(isBookmarked ? .red : .gray)
                    }
//                    .padding([.trailing, .bottom], -8) // 하트 버튼 위치 조정
                }
            }
            .padding(.bottom, 8)
            .frame(width: 150, height: 200)
            .background(Color.white)
            .cornerRadius(7)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
