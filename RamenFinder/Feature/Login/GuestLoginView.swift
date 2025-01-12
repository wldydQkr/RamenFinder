//
//  GuestLoginView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/12/25.
//

import SwiftUI

struct GuestLoginView: View {
    @State private var nickname: String = UserDefaults.standard.string(forKey: "guestNickname") ?? "" // UserDefaults에서 별명 불러오기
    @State private var isLoginComplete: Bool = false // 로그인 완료 상태
    @State private var viewModel: LoginViewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("게스트로 로그인")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("게스트로 로그인하여 라멘 매장을 탐색해보세요!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            //MARK: Input
            TextField("별명을 입력하세요", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)

            //MARK: Login Button
            Button(action: {
                guard !nickname.isEmpty else {
                    print("별명을 입력해주세요.")
                    return
                }
                viewModel.saveNicknameToUserDefaults(nickname)
                print("로그인 성공 - 별명: \(nickname)")
                isLoginComplete = true
            }) {
                Text("게스트로 시작하기")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .fullScreenCover(isPresented: $isLoginComplete) {
            TabBar()
        }
    }
}
