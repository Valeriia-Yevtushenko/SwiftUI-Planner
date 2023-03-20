//
//  ActivityIndicatorView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 15.08.2022.
//

import SwiftUI

struct ActivityIndicatorView: View {
    @State var animate = false
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(AngularGradient(gradient: .init(colors: [.gray, .gray.opacity(0.5)]),
                                         center: .center),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(Angle(degrees: animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7)
                    .repeatForever(autoreverses: false), value: animate)
        }
        .onAppear {
            animate.toggle()
        }
    }
}

struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView()
    }
}
