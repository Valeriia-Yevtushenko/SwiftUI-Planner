//
//  PasswordSecureField.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 21.07.2022.
//

import SwiftUI

struct PasswordSecureField: View {
    @Binding var password: String
    var placeholder: String
        
    var body: some View {
        SecureField(placeholder, text: $password)
            .padding()
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
