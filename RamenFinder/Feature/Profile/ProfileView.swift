//
//  ProfileView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/11/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isEditingNickname = false // 닉네임 수정 화면 상태
    @State private var isImagePickerPresented = false // 이미지 선택 화면 상태

    var body: some View {
        NavigationView {
            VStack {
                // Profile Header
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
                    
                    // 닉네임 표시
                    Text(viewModel.nickname)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("@Allight24")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Edit Profile Button
                    Button(action: {
                        isEditingNickname = true
                    }) {
                        Text("프로필 수정")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.red)
                            .cornerRadius(20)
                    }
                    .sheet(isPresented: $isEditingNickname) {
                        EditNicknameView(viewModel: viewModel)
                    }
                }
                .padding(.vertical, 20)
                
                Divider()
                
                // List Section
                List {
                    Section {
                        ProfileRow(icon: "heart", title: "Favourites")
                        ProfileRow(icon: "globe", title: "Language")
                        ProfileRow(icon: "location", title: "Location")
                    }
                    
                    Section {
                        ProfileRow(icon: "rectangle.portrait.and.arrow.right", title: "Log Out")
                            .foregroundColor(.red)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("My Profile", displayMode: .inline)
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
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ProfileView()
}
