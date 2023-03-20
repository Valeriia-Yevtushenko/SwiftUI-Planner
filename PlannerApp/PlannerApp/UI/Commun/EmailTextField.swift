//
//  EmailTextField.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 26.07.2022.
//

import SwiftUI

struct EmailTextField: View {
    @Binding var email: String
    
    var body: some View {
        TextField("Email", text: $email)
            .padding()
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
