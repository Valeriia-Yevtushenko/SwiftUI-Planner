//
//  ErrorView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 01.08.2022.
//

import SwiftUI

struct ErrorView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .padding()
            .font(.caption2)
            .frame(maxWidth: .infinity, maxHeight: 25)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(5.0)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(title: "Invalid password or username")
    }
}
