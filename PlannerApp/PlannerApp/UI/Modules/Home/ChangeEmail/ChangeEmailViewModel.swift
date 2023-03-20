//
//  ChangeEmailViewModel.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 02.09.2022.
//

import Foundation

class ChangeEmailViewModel: ObservableObject {
    private let authorizationService: AuthorizationServiceProtocol
    private let validationService: ValidationService
    
    init(env: Environment = .current) {
        authorizationService = env.authorizationService
        validationService = env.validationService
    }
    
    func changeEmail(email: String) async throws {
        try validationService.validateEmail(email)
        try await authorizationService.changeEmail(email)
    }
}
