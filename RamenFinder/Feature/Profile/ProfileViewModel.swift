//
//  ProfileViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 1/11/25.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    @Published var nickname: String = ""

    init() {
        loadNickname()
    }

    func loadNickname() {
        // UserDefaults에서 닉네임을 가져오기
        if let savedNickname = UserDefaults.standard.string(forKey: "guestNickname") {
            nickname = savedNickname
        } else {
            nickname = "Guest" // 닉네임이 없을 경우 기본값
        }
    }

    func updateNickname(newNickname: String) {
        nickname = newNickname
        UserDefaults.standard.set(newNickname, forKey: "guestNickname")
    }
}
