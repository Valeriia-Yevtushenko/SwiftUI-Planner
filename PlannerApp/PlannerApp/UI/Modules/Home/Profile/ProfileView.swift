//
//  ProfileView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 08.08.2022.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @State private var presentChangePassword = false
    @State private var presentChangeEmail = false
    
    init() {
        _viewModel = .init(wrappedValue: ProfileViewModel())
    }
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Image("profile")
                    .resizable()
                    .frame(height: 350)
                Text("Hi, \(viewModel.user?.name ?? "")!")
                    .font(.title)
                Spacer()
                changeEmail
                changePassword
                Spacer()
                    .frame(height: 60.0)
                    
                logout
            }
            .padding(20)
            
            Divider().background(.secondary)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .background(Color(UIColor.secondarySystemBackground))
    }
}

private extension ProfileView {
    var logout: some View {
        Button {
            viewModel.logout()
        } label: {
            Text("Log out")
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .frame(maxWidth: .infinity)
                .padding(10)
                .foregroundColor(.white)
                .background(.red)
                .cornerRadius(10)
        }
        .alert(viewModel.error ?? "",
               isPresented: .constant((viewModel.error != nil)),
               actions: {
            Button {
                viewModel.error = nil
            } label: {
                Text("ok")
            }
        })
    }
    
    var changePassword: some View {
        Button {
            presentChangePassword = true
        } label: {
            Text("Change password")
                .frame(maxWidth: .infinity)
                .padding(10)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(10)
        }
        .sheet(isPresented: $presentChangePassword) {
            ChangePasswordView()
        }
    }
    
    var changeEmail: some View {
        Button {
            presentChangeEmail = true
        } label: {
            Text("Change email")
                .frame(maxWidth: .infinity)
                .padding(10)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(10)
        }
        .sheet(isPresented: $presentChangeEmail) {
            ChangeEmailView()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
