//
//  OnboardingItemView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 26.07.2022.
//

import SwiftUI

struct OnboardingItemView: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text(title)
                .font(.title).bold()
            
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 40)
    }
}
