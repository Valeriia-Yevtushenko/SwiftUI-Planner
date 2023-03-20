//
//  TodoView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 11.08.2022.
//

import SwiftUI

struct TodoView: View {
    @ObservedObject var item: Document<Todo>
    var onToggleStatus: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: item.data.isResolved ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(item.data.isResolved ? .gray : .blue)
                .onTapGesture {
                    onToggleStatus()
                }
            Text(item.data.name)
        }
    }
}
