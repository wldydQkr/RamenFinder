//
//  RamenFinderApp.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI
import CoreData

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.white // 배경색 (변경 가능)
                .ignoresSafeArea()

            VStack {
                Image("ramen") // 런치 스크린 로고
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 250)
                
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}

@main
struct RamenFinderApp: App {
    let persistenceController = PersistenceController.shared

    @State private var isLaunchScreenVisible = true // 런치 스크린 상태 관리
    @State private var isOnboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted") // 온보딩 완료 상태
    @State private var isGuestLogin = UserDefaults.standard.string(forKey: "guestNickname") != nil // 별명이 저장되어 있는지 확인

    var body: some Scene {
        WindowGroup {
            if isLaunchScreenVisible {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLaunchScreenVisible = false
                        }
                    }
            } else {
                if isGuestLogin {
                    // guestNickname이 저장되어 있으면 바로 TabBar로 이동
                    NavigationView {
                        TabBar()
                            .environment(\.managedObjectContext, persistenceController.context)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                } else if isOnboardingCompleted {
                    // 온보딩이 완료된 경우 게스트 로그인으로 이동
                    GuestLoginView()
                        .onDisappear {
                            isGuestLogin = true // 게스트 로그인 완료 시 상태 변경
                        }
                } else {
                    // 온보딩이 완료되지 않은 경우 온보딩 화면 표시
                    OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                }
            }
        }
    }
}
