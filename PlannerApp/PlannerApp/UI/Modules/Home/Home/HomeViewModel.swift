//
//  HomeViewModel.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 05.08.2022.
//

import Foundation

class HomeViewModel: ObservableObject {
    private let todoService: any TodoServiceProtocol
    private var currentDate: Date
    private var todos: [Document<Todo>] = []
    @Published var dates: [Date] = []
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
        currentDate = env.date
        selectedDate = currentDate
        todoService = env.todoService
    }
    
    func getNextWeekDates() {
        let calendar = Calendar.current
        self.dates = [0, 1, 2, 3, 4, 5, 6]
            .compactMap {
                calendar.date(byAdding: .day, value: $0, to: currentDate)
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
    
    func updateStatus(_ documentId: String, isResolved: Bool) {
        Task {
            do {
                guard let todo = todos.first(where: { $0.documentId == documentId }),
                      !sections[0].items.isEmpty,
                      !sections[1].items.isEmpty else {
                    return
                }
                
                todo.data.isResolved = isResolved
                try await todoService.update(todo)
                
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

private extension HomeViewModel {
    func updateTodos() {
        sections[0].items = todos.filter { $0.data.isResolved == false }
        sections[1].items = todos.filter { $0.data.isResolved == true }
        processable = todos.isEmpty ? .processedNoValue : .processed
    }
}
