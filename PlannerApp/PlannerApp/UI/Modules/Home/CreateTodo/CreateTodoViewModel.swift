//
//  CreateTodoViewModel.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 16.08.2022.
//

import Foundation

class CreateTodoViewModel: ObservableObject {
    private let todoService: any TodoServiceProtocol
    private let notificationService: NotificationService
    private let userUID: String
    
    init(env: Environment = .current) {
        todoService = env.todoService
        notificationService = env.notificationService
        userUID = env.currentUser?.uid ?? ""
    }
    
    func requestNotifications() {
        Task {
            try? await notificationService.registerNotifications()
        }
    }
    
    func createTodo(_ todo: Todo) async throws {
        let notificationSettings = await notificationService.notificationSettings()
        var notificationId: String = ""
        if notificationSettings == .authorized {
            notificationId = try await notificationService.createNotification(title: "Don't forget!", body: todo.name, date: todo.deadline) ?? ""
        }
        
        todo.userUID = userUID
        todo.notificationId = notificationId
        try await todoService.create(Document(documentId: UUID().uuidString,
                                              data: todo))
    }
}
