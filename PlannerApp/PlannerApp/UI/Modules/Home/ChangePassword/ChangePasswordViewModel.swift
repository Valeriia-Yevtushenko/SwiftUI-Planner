//
//  ChangePasswordViewModel.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 01.09.2022.
//

import Foundation

class ChangePasswordViewModel: ObservableObject {
    private let authorizationService: AuthorizationServiceProtocol
    private let validationService: ValidationService
    private var user: User?
    
    init(env: Environment = .current) {
        user = env.currentUser
        authorizationService = env.authorizationService
        validationService = env.validationService
    }
    
    func changePassword(oldPassword: String,
                        newPassword: String,
                        confirmeNewPassword: String) async throws {
        if oldPassword != user?.password {
            throw ChangePasswordError.wrongOldPassword
        } else if newPassword != confirmeNewPassword {
            throw ChangePasswordError.newPasswordDidNotMatch
        }
        
        try validationService.validatePassword(newPassword)
        try await authorizationService.changePassword(newPassword)
    }
}
