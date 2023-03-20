//
//  EditTodoView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 25.08.2022.
//

import SwiftUI

struct EditTodoView: View {
    @SwiftUI.Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: EditTodoViewModel
    @StateObject private var todo: Todo
    @State private var error: String?
    
    init(todo: Document<Todo>) {
        _todo = .init(wrappedValue: todo.data)
        _viewModel = .init(wrappedValue: EditTodoViewModel(todo: todo))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            title
            Image("create-task-icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            todoTextField            
            editTag
            dateView
            
            if let error = error {
                ErrorView(title: error)
            }
            
            updateButton
            Spacer()
            Divider().background(.secondary)
        }        .padding([.leading, .bottom, .trailing], 10)
        .background(Color(UIColor.secondarySystemBackground))
    }
}

private extension EditTodoView {
    var title: some View {
        HStack {
            Text("Update Todo")
                .font(.title.weight(.semibold))
            Spacer()
        } 
    }
    
    var todoTextField: some View {
        TextField("Todo", text: $todo.name)
            .padding()
            .background(.white)
            .cornerRadius(5.0)
    }
    
    var dateView: some View {
        DatePicker(selection: $todo.deadline,
                   in: Date()...) {
            HStack {
                Image(systemName: "alarm")
                Text(": ")
            }
        }
            .padding(12)
            .background(.white)
            .cornerRadius(5.0)
    }
    
    var editTag: some View {
        HStack {
            Text("Tag:")
            TextField("Add tag", text: $todo.tag)
                .padding()
        }
        .padding(.leading, 10)
        .background(.white)
        .cornerRadius(5.0)
    }
    
    var updateButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.updateTodo(todo)
                    presentationMode.wrappedValue.dismiss()
                } catch {
                    self.error = error.localizedDescription
                }
            }
        } label: {
            Text("Update")
                .padding()
                .frame(maxWidth: .infinity)
                .font(.headline)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(15.0)
        }
    }
}
