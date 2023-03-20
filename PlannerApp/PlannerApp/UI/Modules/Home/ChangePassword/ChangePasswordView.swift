//
//  ChangePasswordView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 01.09.2022.
//

import SwiftUI

struct ChangePasswordView: View {
    @SwiftUI.Environment(\.presentationMode) var presentationMode
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmeNewPassword = ""
    @StateObject var viewModel: ChangePasswordViewModel
    @State private var error: String?
    
    init() {
        _viewModel = .init(wrappedValue: ChangePasswordViewModel())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Change password")
                .font(.title)
                .foregroundColor(.black)
            PasswordSecureField(password: $oldPassword, placeholder: "Old password")
            PasswordSecureField(password: $newPassword, placeholder: "New password")
            PasswordSecureField(password: $confirmeNewPassword, placeholder: "Confirme new password")
            
            if let error = error {
                ErrorView(title: error)
            }
            
            changeButton
        }
        .padding(20)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity, alignment: .top)
        .foregroundColor(.black)
    }
}

private extension ChangePasswordView {
    var changeButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.changePassword(oldPassword: oldPassword,
                                                       newPassword: newPassword,
                                                       confirmeNewPassword: confirmeNewPassword)
                    presentationMode.wrappedValue.dismiss()
                } catch {
                    self.error = error.localizedDescription
                }
            }
        } label: {
            Text("Change")
                .frame(maxWidth: .infinity)
                .padding(10)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(10)
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
