//
//  File.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 30.08.2022.
//

import Foundation

protocol StorageServiceProtocol {
    func set<T: Codable>(_ data: T, key: String)
    func remove(key: String)
    func get<T: Codable>(key: String) -> T?
}
