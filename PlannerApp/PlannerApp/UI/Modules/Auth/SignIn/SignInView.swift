//
//  ContentView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 19.07.2022.
//

import SwiftUI

struct SignInView: View {
    @Binding var appState: AuthFlow
    @State private var email: String = ""
    @State private var password: String = ""
    @StateObject var viewModel: SignInViewModel
    
    init(appState: Binding<AuthFlow>) {
        _viewModel = .init(wrappedValue: SignInViewModel())
        _appState = appState
    }
    
    var body: some View {
        VStack {
            iconImage
            
            if let error = viewModel.error {
                ErrorView(title: error)
            }
            
            EmailTextField(email: $email)
            PasswordSecureField(password: $password, placeholder: "Password")
            
            signInButton
            
            Spacer()
                .frame(height: 20.0)
            
            footer
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.trailing, .leading], 20)
    }
}

private extension SignInView {
    var signInButton: some View {
        Button {
            viewModel.signIn(email: email, password: password)
        } label: {
            Text("Sign In")
                .padding()
                .frame(maxWidth: .infinity)
                .font(.headline)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10.0)
        }
    }
    
    var iconImage: some View {
        Image("main-icon")
            .resizable()
            .frame(width: 200, height: 200, alignment: .center)
            .padding(.bottom, 75)
    }
    
    var footer: some View {
        HStack {
            Text("Don't have an account?")
                .foregroundColor(.gray)
            
            Button {
                appState = .signup
            } label: {
                Text("Sign up")
                    .bold()
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(appState: .constant(.signin))
    }
}
