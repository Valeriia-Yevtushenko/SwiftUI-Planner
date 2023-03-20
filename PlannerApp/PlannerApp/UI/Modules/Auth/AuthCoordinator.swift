//
//  AuthCoordinator.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 02.08.2022.
//

import SwiftUI

enum AuthFlow {
    case onboarding
    case signin
    case signup
}

struct AuthCoordinator: View {
    @State var currentView: AuthFlow = .onboarding
    
    var body: some View {
        switch currentView {
        case .onboarding:
            OnboardingView(appState: $currentView)
        case .signin:
            SignInView(appState: $currentView)
        case .signup:
            SignUpView(appState: $currentView)
        }
    }
}

struct AuthCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        AuthCoordinator()
    }
}
