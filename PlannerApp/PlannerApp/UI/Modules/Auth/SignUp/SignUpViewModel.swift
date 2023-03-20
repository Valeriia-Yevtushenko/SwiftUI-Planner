//
//  SignUpViewModel.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 28.07.2022.
//

import Foundation

class SignUpViewModel: ObservableObject {
    private let validationService: ValidationService
    private let authorizationService: AuthorizationServiceProtocol
    @Published var error: String?
    
    init(env: Environment = .current) {
        self.validationService = env.validationService
        self.authorizationService = env.authorizationService
    }
    
    func signUp(username: String, email: String, password: String) {
        Task {
            do {
                try validationService.validateEmail(email)
                try validationService.validatePassword(password)
                try await authorizationService.createUser(username: username,
                                                          email: email,
                                                          password: password)
                UserDefaults.standard.set(true, forKey: AppKeys.isAuthorized.rawValue)
            } catch let validationError {
                DispatchQueue.main.async {
                    self.error = validationError.localizedDescription
                }
            }
        }
    }
}
