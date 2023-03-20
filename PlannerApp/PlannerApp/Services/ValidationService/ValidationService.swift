//
//  ValidationService.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 26.07.2022.
//

import Foundation

class ValidationService {
    func validateEmail(_ email: String?) throws {
        guard let email = email else {
            throw ValidationError.emptyValue
        }
        
        let emailPattern = #"^\S+@\S+\.\S+$"#
        
        guard email.range(
            of: emailPattern,
            options: .regularExpression) != nil else {
            throw ValidationError.invalidValue
        }
    }
    
    func validatePassword(_ password: String?) throws {
        guard let password = password else {
            throw ValidationError.emptyValue
        }
        
        guard password.count > 8 else {
            throw ValidationError.passwordTooShort
        }
        
        guard password.count < 20 else {
            throw ValidationError.passwordTooLong
        }
    }
}

extension ValidationService {
    enum ValidationError: LocalizedError {
        case invalidValue
        case emptyValue
        case passwordTooShort
        case passwordTooLong
        
        var errorDescription: String? {
            switch self {
            case .invalidValue:
                return "email is invalid"
            case .passwordTooShort:
                return "password is too short "
            case .passwordTooLong:
                return "password is too long"
            case .emptyValue:
                return "value is empty"
            }
        }
    }
}
