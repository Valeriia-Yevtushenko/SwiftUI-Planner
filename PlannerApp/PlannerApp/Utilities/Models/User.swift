//
//  User.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 30.08.2022.
//

import Foundation

struct User: Codable {
    let uid: String
    var email: String
    var name: String
    var password: String
}
