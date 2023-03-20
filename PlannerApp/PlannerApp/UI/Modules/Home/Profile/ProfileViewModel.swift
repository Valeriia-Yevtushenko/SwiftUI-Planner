//
//  ProfileViewModel.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 01.09.2022.
//

import Foundation

class ProfileViewModel: ObservableObject {
    private let authorizationService: AuthorizationServiceProtocol
    @Published var error: String?
    var user: User?
    
    init(env: Environment = .current) {
        user = env.currentUser
        authorizationService = env.authorizationService
    }
    
    func logout() {
        Task {
            do {
                try await authorizationService.signOut()
                UserDefaults.standard.set(false, forKey: AppKeys.isAuthorized.rawValue)
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
}
