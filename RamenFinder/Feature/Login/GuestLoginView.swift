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

    var body: some View {
        VStack(spacing: 20) {
            Text("게스트로 로그인")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("게스트로 로그인하여 라멘 매장을 탐색해보세요!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // 별명 입력 필드
            TextField("별명을 입력하세요", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)

            // 로그인 버튼
            Button(action: {
                guard !nickname.isEmpty else {
                    print("별명을 입력해주세요.")
                    return
                }
                saveNicknameToUserDefaults(nickname) // 별명 저장
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

    // 별명을 UserDefaults에 저장
    private func saveNicknameToUserDefaults(_ nickname: String) {
        UserDefaults.standard.set(nickname, forKey: "guestNickname")
    }
}
