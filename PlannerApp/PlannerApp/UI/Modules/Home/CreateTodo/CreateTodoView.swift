//
//  TodoView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 09.08.2022.
//

import SwiftUI

struct CreateTodoView: View {
    @SwiftUI.Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: CreateTodoViewModel
    @StateObject private var todo: Todo
    @State private var isShowingTag = false
    @State private var error: String?
    
    init() {
        _todo = .init(wrappedValue: Todo(name: "",
                                         deadline: .now,
                                         isResolved: false,
                                         userUID: "",
                                         tag: "",
                                         notificationId: ""))
        _viewModel = .init(wrappedValue: CreateTodoViewModel())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            title
            Image("create-task-icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            todoTextField
            
            if isShowingTag {
                tagView
            } else {
                addTag
            }
             
            dateView
            
            if let error = error {
                ErrorView(title: error)
            }
            
            createButton
            Spacer()
            Divider().background(.secondary)
        }
        .padding([.leading, .bottom, .trailing], 10)
        .background(Color(UIColor.secondarySystemBackground))
        .onAppear {
            viewModel.requestNotifications()
        }
    }
}

private extension CreateTodoView {
    var title: some View {
        HStack {
            Text("Create Todo")
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
    
    var tagView: some View {
        HStack {
            Text("Tag: ")
            Spacer()
            Text("#\(todo.tag)")
                .padding(5)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(5.0)
        }
        .padding(15)
        .background(.white)
        .cornerRadius(5.0)
    }
    
    var addTag: some View {
        HStack {
            TextField("Add tag", text: $todo.tag)
                .padding()
            Button {
                isShowingTag = true
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 10, height: 10)
                    .padding(8)
            }
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(.infinity)
        }
        .padding(.leading, 10)
        .background(.white)
        .cornerRadius(5.0)
    }
    
    var createButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.createTodo(todo)
                    presentationMode.wrappedValue.dismiss()
                } catch {
                    self.error = error.localizedDescription
                }
            }
        } label: {
            Text("Create")
                .padding()
                .frame(maxWidth: .infinity)
                .font(.headline)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(15.0)
        }
    }
}

struct CreateTodoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTodoView()
    }
}
