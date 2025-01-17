//
//  ProfileViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 1/11/25.
//

import Foundation
import UIKit

final class ProfileViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var profileImage: UIImage? = nil // 프로필 이미지를 저장할 프로퍼티

    init() {
        loadProfile()
    }

    // 프로필 데이터 로드
    func loadProfile() {
        loadNickname()
        loadProfileImage()
    }

    // 닉네임 로드
    private func loadNickname() {
        if let savedNickname = UserDefaults.standard.string(forKey: "guestNickname") {
            nickname = savedNickname
        } else {
            nickname = "게스트" // 기본 닉네임
        }
    }

    // 닉네임 업데이트
    func updateNickname(newNickname: String) {
        nickname = newNickname
        UserDefaults.standard.set(newNickname, forKey: "guestNickname")
    }

    // 프로필 이미지 로드
    private func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImage"),
           let image = UIImage(data: imageData) {
            profileImage = image
        } else {
            profileImage = nil // 기본값
        }
    }

    // 프로필 이미지 업데이트
    func updateProfileImage(newImage: UIImage) {
        profileImage = newImage
        if let imageData = newImage.jpegData(compressionQuality: 0.8) { // 이미지를 JPEG 형식으로 저장
            UserDefaults.standard.set(imageData, forKey: "profileImage")
        }
    }
}
