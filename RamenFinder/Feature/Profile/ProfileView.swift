//
//  ProfileView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/11/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isEditingNickname = false
    @State private var isImagePickerPresented = false

    var body: some View {
        NavigationView {
            VStack {
                Text("프로필 설정")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                //MARK: Header Section
                VStack(spacing: 10) {
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                    } else {
                        Image("ramen") // 기본 이미지
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                    }
                    
                    // 이름
                    Text(viewModel.nickname)
                        .font(.title2)
                        .fontWeight(.bold)
                    
//                    Text("@Allight24")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
                    
                    // 프로필 수정 버튼
                    Button(action: {
                        isEditingNickname = true
                    }) {
                        Text("프로필 수정")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(CustomColor.primary)
                            .cornerRadius(20)
                    }
                    .sheet(isPresented: $isEditingNickname) {
                        EditNicknameView(viewModel: viewModel)
                    }
                }
                .padding(.vertical, 20)
                
                Divider()
                
                //MARK: List Section
                List {
                    Section {
                        ProfileRow(icon: "heart", title: "찜한 매장")
                        NavigationLink(destination: RamenRecommendationView()) {
                            ProfileRow(icon: "hand.thumbsup", title: "라멘 추천 받기")
                        }
                        ProfileRow(icon: "location", title: "위치설정")
                        ProfileRow(icon: "mail", title: "피드백")
                        ProfileRow(icon: "gear", title: "앱 정보")
                    }
                    
//                    Section {
//                        ProfileRow(icon: "rectangle.portrait.and.arrow.right", title: "Log Out")
//                            .foregroundColor(.red)
//                    }
                }
                .listStyle(PlainListStyle())
            }
//            .navigationBarTitle("My Profile", displayMode: .inline)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: Binding(
                    get: { viewModel.profileImage },
                    set: { newImage in
                        if let newImage = newImage {
                            viewModel.updateProfileImage(newImage: newImage)
                        }
                    }
                ))
            }
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.gray)
            Text(title)
                .font(.body)
            Spacer()
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ProfileView()
}
