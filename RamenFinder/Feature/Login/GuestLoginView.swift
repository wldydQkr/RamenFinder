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
            Text("게스트로 로그인")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("게스트로 로그인하여 라멘 매장을 탐색해보세요!")
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
                    .shadow(radius: 5)
            }

            // 이미지 선택 버튼
            Button(action: {
                isImagePickerPresented = true
            }) {
                Text("프로필 이미지 선택")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
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
                Text("게스트로 시작하기")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(nickname.isEmpty ? Color.gray : Color.green)
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

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    GuestLoginView()
}
