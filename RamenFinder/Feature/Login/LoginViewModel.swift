//
//  LoginViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 1/12/25.
//

import Foundation
import UIKit

class LoginViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var profileImage: UIImage? = nil

    init() {
        loadNickname()
        loadProfileImage()
    }

    // 닉네임 저장
    func saveNicknameToUserDefaults(_ nickname: String) {
        self.nickname = nickname
        UserDefaults.standard.set(nickname, forKey: "guestNickname")
    }

    // 닉네임 로드
    func loadNickname() {
        nickname = UserDefaults.standard.string(forKey: "guestNickname") ?? ""
    }

    // 이미지 저장
    func saveProfileImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: "profileImage")
        }
    }

    // 이미지 로드
    func loadProfileImage() {
        if let data = UserDefaults.standard.data(forKey: "profileImage"),
           let image = UIImage(data: data) {
            profileImage = image
        }
    }
}
