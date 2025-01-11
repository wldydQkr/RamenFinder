//
//  RamenFinderApp.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI
import CoreData

import SwiftUI

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
                
//                Text("RamenFinder")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}

@main
struct RamenFinderApp: App {
    let persistenceController = PersistenceController.shared // Core Data 관리 싱글톤 인스턴스

    @State private var isLaunchScreenVisible = true // 런치 스크린 상태 관리

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
                NavigationView {
                    TabBar()
                        .environment(\.managedObjectContext, persistenceController.context) // Core Data 컨텍스트 주입
                }
                .navigationViewStyle(StackNavigationViewStyle()) // 모든 디바이스에서 Stack 스타일 강제
            }
        }
    }
}
