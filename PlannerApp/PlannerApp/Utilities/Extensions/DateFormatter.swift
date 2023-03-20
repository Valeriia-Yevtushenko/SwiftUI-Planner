//
//  DateFormatter.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 29.08.2022.
//

import Foundation

extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
}
