//
//  TodoService.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 05.08.2022.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class FirebaseTodoService: TodoServiceProtocol {
    private let database = Firestore.firestore()
    private let collection = "todos"
    private var userUID: (String, String) {
        ("userUID", Environment.current.currentUser?.uid ?? "")
    }
}

extension FirebaseTodoService {
    typealias TodoModel = Document<Todo>
    
    func get(by date: Date) async throws -> [TodoModel] {
        let key = "deadline"
        
        do {
            let querySnapshot = try await database.collection(collection)
                .whereField(key, isDateInToday: date)
                .whereField(userUID.0, isEqualTo: userUID.1)
                .getDocuments()
            
            let todos: [TodoModel] = querySnapshot.documents.compactMap {
                var data = $0.data()
                guard let timestamp = data[key] as? Timestamp else {
                    return nil
                }
                
                data[key] = timestamp.dateValue()
                
                guard let documetData = Todo(from: data) else {
                    return nil
                }
                
                return TodoModel(documentId: $0.documentID, data: documetData)
            }
            
            return todos
        } catch {
            throw error
        }
    }
    
    func create(_ document: TodoModel) async throws {
        try await database.collection(collection).document(document.documentId).setData(document.data.dict)
    }
    
    func update(_ document: TodoModel) async throws {
        try await database.collection(collection).document(document.documentId).updateData(document.data.dict)
    }
    
    func delete(_ documentId: String) async throws {
        try await database.collection(collection).document(documentId).delete()
    }
}
