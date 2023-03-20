//
//  Environment.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 27.07.2022.
//

import Foundation
import FirebaseAuth

class Environment {
    let validationService: ValidationService
    let authorizationService: AuthorizationServiceProtocol
    let todoService: any TodoServiceProtocol
    let storageService: StorageServiceProtocol
    let notificationService: NotificationService
    let date = Date.now
    
    var currentUser: User? {
        storageService.get(key: AppKeys.user.rawValue)
    }
    
    init() {
        storageService = StorageService()
        validationService = ValidationService()
        authorizationService = FirebaseAuthorizationService(storageService: storageService)
        todoService = SQLiteTodoService()
        notificationService = NotificationService()
    }
}

extension Environment {
    static let current = Environment()
}
