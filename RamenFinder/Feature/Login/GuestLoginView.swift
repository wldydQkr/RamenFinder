//
//  GuestLoginView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/12/25.
//

import SwiftUI

struct GuestLoginView: View {
    @State private var nickname: String = ""
    @State private var isLoginComplete: Bool = false
    @StateObject private var viewModel: LoginViewModel = LoginViewModel()

    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("프로필 설정하기")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("프로필을 설정하고 라멘 매장을 탐색해보세요!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // 프로필 이미지
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .shadow(radius: 5)
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }

            // 이미지 선택 버튼
            Button(action: {
                isImagePickerPresented = true
            }) {
                Text("프로필 이미지 선택")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(CustomColor.secondary)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)

            // 닉네임 입력
            TextField("별명을 입력하세요", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)

            // 게스트 시작 버튼
            Button(action: {
                guard !nickname.isEmpty else {
                    print("별명을 입력해주세요.")
                    return
                }
                viewModel.saveNicknameToUserDefaults(nickname)
                if let image = selectedImage {
                    viewModel.saveProfileImage(image)
                }
                print("로그인 성공 - 별명: \(nickname)")
                isLoginComplete = true
            }) {
                Text("시작하기")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(nickname.isEmpty ? Color.gray : CustomColor.primary)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .disabled(nickname.isEmpty)
        }
        .padding()
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .fullScreenCover(isPresented: $isLoginComplete) {
            TabBar()
        }
        .onAppear {
            nickname = viewModel.nickname
            selectedImage = viewModel.profileImage
        }
    }
}

#Preview {
    GuestLoginView()
}
