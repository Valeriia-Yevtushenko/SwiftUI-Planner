//
//  AuthorizationService.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 01.08.2022.
//

import Foundation
import FirebaseAuth

class FirebaseAuthorizationService {
    let storageService: StorageServiceProtocol
    
    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }
}

extension FirebaseAuthorizationService: AuthorizationServiceProtocol {
    func createUser(username: String,
                    email: String,
                    password: String) async throws {
        let authData = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeRequest = authData.user.createProfileChangeRequest()
        changeRequest.displayName = username
        try await changeRequest.commitChanges()
        self.storageService.set(User(uid: authData.user.uid,
                                     email: email,
                                     name: username,
                                     password: password),
                                key: AppKeys.user.rawValue)
    }
    
    func signIn(email: String,
                password: String) async throws {
        let authData = try await Auth.auth().signIn(withEmail: email, password: password)
        self.storageService.set(User(uid: authData.user.uid,
                                     email: email,
                                     name: authData.user.displayName ?? "",
                                     password: password),
                                key: AppKeys.user.rawValue)
    }
    
    func changePassword(_ password: String) async throws {
        guard var user: User = storageService.get(key: AppKeys.user.rawValue) else {
            return
        }
        
        try await signIn(email: user.email, password: user.password)
        try await Auth.auth().currentUser?.updatePassword(to: password)
        user.password = password
        storageService.set(user, key: AppKeys.user.rawValue)
    }
    
    func changeEmail(_ email: String) async throws {
        guard var user: User = storageService.get(key: AppKeys.user.rawValue) else {
            return
        }
        
        try await signIn(email: user.email, password: user.password)
        try await Auth.auth().currentUser?.updateEmail(to: email)
        user.email = email
        storageService.set(user, key: AppKeys.user.rawValue)
    }
    
    func signOut() async throws {
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        do {
            try Auth.auth().signOut()
        } catch {
           throw error
        }
    }
}
