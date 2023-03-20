//
//  Result.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 12.08.2022.
//

import Foundation

enum ChangePasswordError: Error {
    case wrongOldPassword
    case newPasswordDidNotMatch
}

extension ChangePasswordError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongOldPassword:
            return "The old password does not match"
        case .newPasswordDidNotMatch:
            return "The new password does not match"
        }
    }
}
