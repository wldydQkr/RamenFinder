//
//  EditNicknameView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/14/25.
//

import SwiftUI

struct EditNicknameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProfileViewModel // 기존 ViewModel을 공유

    @State private var newNickname: String = ""

    var body: some View {
        ZStack {
            // 투명한 배경을 사용
            Color.clear
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // 배경을 탭하면 닫힘
                    presentationMode.wrappedValue.dismiss()
                }

            // 플로팅 카드
            VStack(spacing: 20) {
                Text("Edit Your Nickname")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                TextField("Enter new nickname", text: $newNickname)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                Button(action: {
                    if !newNickname.isEmpty {
                        viewModel.updateNickname(newNickname: newNickname)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(newNickname.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(newNickname.isEmpty)

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 30)
            .scaleEffect(1.05) // 살짝 확대된 느낌
            .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0), value: newNickname)
        }
        .onAppear {
            newNickname = viewModel.nickname // 기존 닉네임 표시
        }
    }
}
