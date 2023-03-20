//
//  ChangeEmailView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 02.09.2022.
//

import SwiftUI

struct ChangeEmailView: View {
    @SwiftUI.Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @StateObject var viewModel: ChangeEmailViewModel
    @State private var error: String?
    
    init() {
        _viewModel = .init(wrappedValue: ChangeEmailViewModel())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Change Email")
                .font(.title)
                .foregroundColor(.black)
            EmailTextField(email: $email)
            
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

private extension ChangeEmailView {
    var changeButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.changeEmail(email: email)
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

struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailView()
    }
}
