//
//  SignInViewModel.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 26.07.2022.
//

import Foundation

class SignInViewModel: ObservableObject {
    private let authorizationService: AuthorizationServiceProtocol
    @Published var error: String?
    
    init(env: Environment = .current) {
        authorizationService = env.authorizationService
    }
    
    func signIn(email: String, password: String) {
        Task {
            do {
                try await authorizationService.signIn(email: email, password: password)
                UserDefaults.standard.set(true, forKey: AppKeys.isAuthorized.rawValue)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
