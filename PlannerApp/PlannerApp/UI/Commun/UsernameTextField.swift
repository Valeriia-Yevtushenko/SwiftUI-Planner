//
//  UsernameTextField.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 21.07.2022.
//

import SwiftUI

struct UsernameTextField: View {
    @Binding var username: String
    
    var body: some View {
        TextField("Username", text: $username)
            .padding()
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
