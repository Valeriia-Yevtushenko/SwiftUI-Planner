//
//  TodoServiceProtocol.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 26.09.2022.
//

import Foundation

protocol TodoServiceProtocol {
    associatedtype TodoModel
    func get(by date: Date) async throws -> [TodoModel]
    func create(_ document: Document<Todo>) async throws
    func update(_ document: Document<Todo>) async throws
    func delete(_ documentId: String) async throws
}
