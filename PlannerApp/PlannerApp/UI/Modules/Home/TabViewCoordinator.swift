//
//  HomeCoordinator.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 02.08.2022.
//

import SwiftUI

struct TabViewCoordinator: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "list.bullet.rectangle.portrait")
                }
            ProfileView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
     
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .secondarySystemBackground
        }
    }
}

struct HomeCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        TabViewCoordinator()
    }
}
