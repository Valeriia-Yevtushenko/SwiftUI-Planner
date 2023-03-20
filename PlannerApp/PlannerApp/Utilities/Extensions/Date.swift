//
//  Date.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 29.08.2022.
//

import Foundation

extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}
