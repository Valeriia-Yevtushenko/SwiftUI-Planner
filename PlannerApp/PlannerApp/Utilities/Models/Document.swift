//
//  DatabaseModel.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 12.08.2022.
//

import Foundation

class Document<T: Codable> {
    let documentId: String
    var data: T
    
    init(documentId: String,
         data: T) {
        self.documentId = documentId
        self.data = data
    }
}

extension Document: Identifiable {}

extension Document: Hashable {
    static func == (lhs: Document, rhs: Document) -> Bool {
        lhs.documentId == rhs.documentId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(documentId)
    }
}

extension Document: ObservableObject {}
