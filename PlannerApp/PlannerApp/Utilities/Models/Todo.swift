//
//  Todo.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 05.08.2022.
//

import Foundation

class Todo: Codable {
    var name: String
    var deadline: Date
    var isResolved: Bool
    var tag: String
    var userUID: String
    var notificationId: String
    
    init(name: String,
         deadline: Date,
         isResolved: Bool,
         userUID: String,
         tag: String,
         notificationId: String) {
        self.name = name
        self.deadline = deadline
        self.isResolved = isResolved
        self.tag = tag
        self.userUID = userUID
        self.notificationId = notificationId
    }
    
    init?(from dict: [String: Any]) {
        guard let name = dict["name"] as? String,
              let deadline = dict["deadline"] as? Date,
              let isResolved = dict["isResolved"] as? Bool,
              let userUID = dict["userUID"] as? String,
              let tag = dict["tag"] as? String,
              let notificationId = dict["notificationId"] as? String else {
            return nil
        }
        
        self.name = name
        self.deadline = deadline
        self.isResolved = isResolved
        self.tag = tag
        self.userUID = userUID
        self.notificationId = notificationId
    }
    
    var dict: [String: Any] {
        ["name": name,
         "deadline": deadline,
         "isResolved": isResolved,
         "tag": tag,
         "userUID": userUID,
         "notificationId": notificationId]
    }
}

extension Todo: ObservableObject {}
