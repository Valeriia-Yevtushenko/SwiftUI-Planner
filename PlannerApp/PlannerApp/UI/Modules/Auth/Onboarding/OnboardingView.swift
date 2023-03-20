//
//  OnboardingView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 26.07.2022.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var appState: AuthFlow
    @State private var selectedPage = 0
    
    var body: some View {
        VStack {
            pages
            button
        }
    }
}

private extension OnboardingView {
    var button: some View {
        Button {
            withAnimation {
                if selectedPage == 2 {
                    appState = .signin
                } else {
                    selectedPage += 1
                }
            }
        } label: {
            Text((selectedPage == 2) ? "Get Started": "Next")
                .padding()
                .frame(maxWidth: .infinity)
                .font(.headline)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(15.0)
        
        }.padding([.trailing, .leading, .bottom], 30)
    }
    
    var pages: some View {
        TabView(selection: $selectedPage) {
            OnboardingItemView(imageName: "onboarding-icon1",
                               title: "Manage your tasks",
                               description: "You can easily manage all of your daily tasks in DoMe for free").tag(0)
            OnboardingItemView(imageName: "onboarding-icon2",
                               title: "Create daily routine",
                               description: "In Uptodo  you can create your personalized routine to stay productive").tag(1)
            OnboardingItemView(imageName: "onboarding-icon3",
                               title: "Orgonaize your tasks",
                               description: "You can organize your daily tasks by adding your tasks into separate categories").tag(2)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(appState: .constant(.onboarding))
    }
}
