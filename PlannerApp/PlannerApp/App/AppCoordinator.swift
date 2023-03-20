//
//  AppCoordinator.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 02.08.2022.
//

import SwiftUI

struct AppCoordinator: View {
    @AppStorage(AppKeys.isAuthorized.rawValue) var isAuthorized: Bool = UserDefaults.standard.bool(forKey: AppKeys.isAuthorized.rawValue)
    
    var body: some View {
        if isAuthorized {
            TabViewCoordinator()
        } else {
            AuthCoordinator()
        }
    }
}
