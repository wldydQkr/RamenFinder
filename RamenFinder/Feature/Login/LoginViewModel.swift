//
//  LoginViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 1/12/25.
//

import Foundation

final class LoginViewModel {
    
    // 별명을 UserDefaults에 저장
    func saveNicknameToUserDefaults(_ nickname: String) {
        UserDefaults.standard.set(nickname, forKey: "guestNickname")
    }
    
}
