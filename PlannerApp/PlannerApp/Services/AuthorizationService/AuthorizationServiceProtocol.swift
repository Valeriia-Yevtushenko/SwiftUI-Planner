//
//  AuthorizationServiceProtocol.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 01.08.2022.
//

import Foundation

protocol AuthorizationServiceProtocol: AnyObject {
    func createUser(username: String,
                    email: String,
                    password: String) async throws
    func signIn(email: String,
                password: String) async throws
    func changePassword(_ password: String) async throws
    func changeEmail(_ email: String) async throws
    func signOut() async throws
}
