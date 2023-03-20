//
//  CollectionItemView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 04.08.2022.
//

import SwiftUI

struct DateView: View {
    private let formatter: DateFormatter
    let date: Date
    
    var day: Day {
        let result = formatter.string(from: date).split(separator: " ")
        return Day(date: String(result[1]),
                   name: String(result[0]))
    }
    
    init(date: Date) {
        self.date = date
        self.formatter = DateFormatter()
        formatter.dateFormat = "E' 'd"
        formatter.locale = Locale(identifier: "en_US")
    }
    
    var body: some View {
        VStack {
            Text(day.name)
                .font(.body.smallCaps())
            Text(day.date)
                .font(.title2
                    .weight(.semibold))
        }
        .padding()
        .foregroundColor(.black)
        .background(Color("day-color"))
        .cornerRadius(10)
    }
}

struct CollectionItemView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(date: Date.now)
    }
}
