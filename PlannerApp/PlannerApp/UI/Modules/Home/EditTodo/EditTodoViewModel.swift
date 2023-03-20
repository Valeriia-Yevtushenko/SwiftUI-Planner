//
//  EditTodoViewModel.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 25.08.2022.
//

import SwiftUI

class EditTodoViewModel: ObservableObject {
    private let todoService: any TodoServiceProtocol
    private let notificationService: NotificationService
    @ObservedObject var todo: Document<Todo>
    
    init(env: Environment = .current, todo: Document<Todo>) {
        todoService = env.todoService
        notificationService = env.notificationService
        _todo = .init(wrappedValue: todo)
    }
    
    func updateTodo(_ todo: Todo) async throws {
        if !todo.notificationId.isEmpty {
            notificationService.removeNotification(todo.notificationId)
        }
        
        let notificationSettings = await notificationService.notificationSettings()
        var notificationId: String = ""
        
        if notificationSettings == .authorized {
            notificationId = try await notificationService.createNotification(title: "Don't forget!", body: todo.name, date: todo.deadline) ?? ""
        }
        
        todo.notificationId = notificationId
        try await todoService.update(Document(documentId: self.todo.documentId,
                                              data: todo))
        self.todo.data = todo
    }
}
