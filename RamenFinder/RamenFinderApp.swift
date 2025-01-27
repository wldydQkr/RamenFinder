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

struct RootView: View {
    @Binding var isLaunchScreenVisible: Bool
    @Binding var isOnboardingCompleted: Bool
    @Binding var isGuestLogin: Bool

    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            if isLaunchScreenVisible {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLaunchScreenVisible = false
                        }
                    }
            } else {
                if isGuestLogin {
                    TabBar()
                        .navigationBarBackButtonHidden(true) // 뒤로가기 버튼 숨김
                } else if isOnboardingCompleted {
                    GuestLoginView()
                        .onDisappear {
                            isGuestLogin = true
                        }
                } else {
                    OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)

                }
            }
        }
    }
}

@main
struct RamenFinderApp: App {
    let persistenceController = PersistenceController.shared

    @State private var isLaunchScreenVisible = true
    @State private var isOnboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
    @State private var isGuestLogin = UserDefaults.standard.string(forKey: "guestNickname") != nil

    var body: some Scene {
        WindowGroup {
            RootView(
                isLaunchScreenVisible: $isLaunchScreenVisible,
                isOnboardingCompleted: $isOnboardingCompleted,
                isGuestLogin: $isGuestLogin
            )
            .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
