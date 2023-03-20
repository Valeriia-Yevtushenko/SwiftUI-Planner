//
//  Calendar.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 29.08.2022.
//

import SwiftUI

public struct CalendarViewComponent<Day: View, Header: View, Title: View, Trailing: View>: View {
    private var calendar: Calendar
    private let daysInWeek = 7
    private let day: (Date) -> Day
    private let trailingDay: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title
    @Binding private var date: Date

    public init(calendar: Calendar,
                date: Binding<Date>,
                @ViewBuilder day: @escaping (Date) -> Day,
                @ViewBuilder trailingDay: @escaping (Date) -> Trailing,
                @ViewBuilder header: @escaping (Date) -> Header,
                @ViewBuilder title: @escaping (Date) -> Title) {
        _date = date
        self.calendar = calendar
        self.day = day
        self.trailingDay = trailingDay
        self.header = header
        self.title = title
    }

    public var body: some View {
        let month = date.startOfMonth(using: calendar)

        return LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
            SwiftUI.Section(header: title(month)) {
                ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                ForEach(days, id: \.self) { date in
                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                        day(date)
                    } else {
                        trailingDay(date)
                    }
                }
            }
        }
    }
}

private extension CalendarViewComponent {
    
}

extension CalendarViewComponent: Equatable {
    public static func == (lhs: CalendarViewComponent<Day, Header, Title, Trailing>,
                           rhs: CalendarViewComponent<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}

private extension CalendarViewComponent {
    var days: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }

        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
}
