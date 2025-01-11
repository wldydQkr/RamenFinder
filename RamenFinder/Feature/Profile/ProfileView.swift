//
//  ProfileView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/11/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Profile Header
                VStack(spacing: 10) {
                    Image("profile_image")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                    
                    Text("올라잇 정진")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("@AllightAllightAllight")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        // Edit Profile Action
                    }) {
                        Text("Edit Profile")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.red)
                            .cornerRadius(20)
                    }
                }
                .padding(.vertical, 20)
                
                Divider()
                
                // List Section
                List {
                    Section {
                        ProfileRow(icon: "heart", title: "Favourites")
                        ProfileRow(icon: "arrow.down.to.line", title: "Downloads")
                        ProfileRow(icon: "globe", title: "Language")
                        ProfileRow(icon: "location", title: "Location")
                        ProfileRow(icon: "creditcard", title: "Subscription")
                    }
                    
                    Section {
                        ProfileRow(icon: "trash", title: "Clear Cache")
                        ProfileRow(icon: "clock.arrow.circlepath", title: "Clear History")
                    }
                    
                    Section {
                        ProfileRow(icon: "rectangle.portrait.and.arrow.right", title: "Log Out")
                            .foregroundColor(.red)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitle("My Profile", displayMode: .inline)
            .navigationBarItems(
//                leading: Button(action: {
//                    // Back Action
//                }) {
//                    Image(systemName: "chevron.left")
//                },
                trailing: Button(action: {
                    // Settings Action
                }) {
                    Image(systemName: "gearshape")
                }
            )
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.gray)
            Text(title)
                .font(.body)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ProfileView()
}
