//
//  CalendarViewModel.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 29.08.2022.
//

import Foundation

class CalendarViewModel: ObservableObject {
    private let todoService: any TodoServiceProtocol
    private var todos: [Document<Todo>] = []
    @Published var processable: Processable = .processing
    var sections: [Section] = [Section(type: .todo,
                                                  items: []),
                                          Section(type: .resolved,
                                                  items: [])]
    @Published var selectedDate: Date {
        didSet {
            getTodos()
        }
    }
    
    init(env: Environment = .current) {
        todoService = env.todoService
        selectedDate = .now
    }
    
    func getTodos() {
        processable = .processing
        Task {
            do {
                self.todos = try await todoService.get(by: selectedDate) as? [Document<Todo>] ?? []
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateTodos()
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.processable = .failure("Oops, somthing went wrong...")
                }
            }
        }
    }
    
    func updateStatus(_ todo: Document<Todo>) {
        Task {
            do {
                try await todoService.update(todo)
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateTodos()
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    todo.data.isResolved.toggle()
                    self?.processable = .failure("Oops, somthing went wrong...")
                }
            }
        }
    }
    
    func delete(_ todo: Document<Todo>) {
        Task {
            do {
                try await todoService.delete(todo.documentId)
                
                DispatchQueue.main.async { [weak self] in
                    guard let index = self?.todos.firstIndex(of: todo) else {
                        return
                    }
                    
                    self?.todos.remove(at: index)
                    self?.updateTodos()
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.processable = .failure("Oops, somthing went wrong...")
                }
            }
        }
    }
}

private extension CalendarViewModel {
    func updateTodos() {
        sections[0].items = todos.filter { $0.data.isResolved == false }
        sections[1].items = todos.filter { $0.data.isResolved == true }
        processable = todos.isEmpty ? .processedNoValue : .processed
    }
}
