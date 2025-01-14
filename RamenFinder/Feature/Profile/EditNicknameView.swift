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
        NavigationView {
            Form {
                Section(header: Text("Edit Your Nickname")) {
                    TextField("Enter new nickname", text: $newNickname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                }
                
                Button(action: {
                    if !newNickname.isEmpty {
                        viewModel.updateNickname(newNickname: newNickname)
                        presentationMode.wrappedValue.dismiss() // 닉네임 업데이트 후 닫기
                    }
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.vertical)
                .disabled(newNickname.isEmpty)
            }
            .navigationBarTitle("Edit Nickname", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            newNickname = viewModel.nickname // 기존 닉네임 표시
        }
    }
}

//#Preview {
//    EditNicknameView(presentationMode: <#T##arg#>, viewModel: <#T##ProfileViewModel#>, newNickname: <#T##String#>)
//}
