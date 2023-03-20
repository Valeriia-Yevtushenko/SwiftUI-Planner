//
//  SignUp.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 26.07.2022.
//

import SwiftUI

struct SignUpView: View {
    @Binding var appState: AuthFlow
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @StateObject var viewModel: SignUpViewModel
    
    init(appState: Binding<AuthFlow>) {
        _viewModel = .init(wrappedValue: SignUpViewModel())
        _appState = appState
    }
    
    var body: some View {
        VStack {
            Image("main-icon")
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
                .padding(.bottom, 40)
            
            if let error = viewModel.error {
                ErrorView(title: error)
            }
            
            UsernameTextField(username: $username)
            EmailTextField(email: $email)
            PasswordSecureField(password: $password, placeholder: "Password")
            
            signUpButton
            
            Spacer()
                .frame(height: 20.0)
            
            footer
        }.padding([.trailing, .leading], 20)
    }
}

private extension SignUpView {
    var signUpButton: some View {
        Button {
            viewModel.signUp(username: username,
                             email: email,
                             password: password)
        } label: {
            Text("Sign Up")
                .padding()
                .frame(maxWidth: .infinity)
                .font(.headline)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(15.0)
        }
    }
    
    var footer: some View {
        HStack {
            Text("Already have an account?")
                .foregroundColor(.gray)
            Button {
                appState = .signin
            } label: {
                Text("Sign in")
                    .bold()
            }
        }
    }
    
    var error: some View {
        Text("Invalid password or username")
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 25)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(5.0)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(appState: .constant(.signup))
    }
}
