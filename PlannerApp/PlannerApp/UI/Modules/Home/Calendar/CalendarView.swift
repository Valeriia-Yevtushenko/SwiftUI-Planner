//
//  CalendarView.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 29.08.2022.
//

import SwiftUI

struct CalendarView: View {
    private let calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    @StateObject var viewModel: CalendarViewModel

    init(calendar: Calendar) {
        _viewModel = .init(wrappedValue: CalendarViewModel())
        self.calendar = calendar
        
        self.monthFormatter = DateFormatter(dateFormat: "MMMM", calendar: calendar)
        self.monthFormatter.locale = Locale(identifier: "en_US")
        
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.dayFormatter.locale = Locale(identifier: "en_US")
        
        self.weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: calendar)
        self.weekDayFormatter.locale = Locale(identifier: "en_US")
    }

    var body: some View {
        VStack {
            calendarView
            
            switch viewModel.processable {
            case .processing:
                loadingView
            case .processedNoValue:
                emptyMessageView
            case .processed:
                list
            case .failure(let error):
                VStack {
                    Spacer()
                    Image("smth-went-wrong")
                        .resizable()
                        .frame(width: 300, height: 300)
                    Text(error)
                    Spacer()
                }
            }
            
            Divider().background(.secondary)
        }
        .navigationTitle(Text("Calendar"))
        .background(Color(UIColor.secondarySystemBackground))
        .onAppear {
            viewModel.getTodos()
        }
    }
}

extension CalendarView {
    var calendarView: some View {
        CalendarViewComponent(
            calendar: calendar,
            date: $viewModel.selectedDate,
            day: { date in
                Button {
                    viewModel.selectedDate = date
                } label: {
                    Text("00")
                        .padding(8)
                        .foregroundColor(.clear)
                        .background(
                            calendar.isDate(date, inSameDayAs: viewModel.selectedDate) ? .black
                                : calendar.isDateInToday(date) ? .red
                                : .blue
                        )
                        .cornerRadius(8)
                        .overlay(
                            Text(dayFormatter.string(from: date))
                                .foregroundColor(.white)
                        )
                }
            },
            trailingDay: { date in
                Text(dayFormatter.string(from: date))
                    .foregroundColor(.secondary)
            },
            header: { date in
                Text(weekDayFormatter.string(from: date))
            },
            title: { date in
                HStack {
                    Text(monthFormatter.string(from: date))
                        .font(.headline)
                        .padding()
                    
                    Spacer()
                    
                    Button {
                        guard let newDate = calendar.date(
                            byAdding: .month,
                            value: -1,
                            to: viewModel.selectedDate) else {
                            return
                        }

                        viewModel.selectedDate = newDate
                    } label: {
                        Image(systemName: "chevron.left")
                            .padding(.horizontal)
                            .frame(maxHeight: .infinity)
                    }
                    Button {
                            guard let newDate = calendar.date(
                                byAdding: .month,
                                value: 1,
                                to: viewModel.selectedDate) else {
                                return
                            }

                        viewModel.selectedDate = newDate
                        
                    } label: {
                        Image(systemName: "chevron.right")
                            .padding(.horizontal)
                            .frame(maxHeight: .infinity)
                    }
                }
                .padding(.bottom, 6)
            }
        )
        .equatable()
    }
    
    var list: some View {
        List {
            ForEach(viewModel.sections, id: \.self.type.rawValue) { section in
                if !section.items.isEmpty {
                    SwiftUI.Section(header:
                                        Text(section.type.rawValue)
                                        .font(.title3
                                            .weight(.semibold))
                                        .foregroundColor(.black),
                                    content: {
                        ForEach(section.items, id: \.self) { item in
                            NavigationLink(destination: EditTodoView(todo: item)) {
                                TodoView(item: item, onToggleStatus: {
                                    item.data.isResolved.toggle()
                                    viewModel.updateStatus(item)
                                })
                            }
                        }
                        .onDelete { offSets in
                            for offset in offSets {
                                viewModel.delete(section.items[offset])
                            }
                            
                        }
                    })
                }
            }
        }
    }
    
    var emptyMessageView: some View {
        VStack {
            Spacer()
            Image("onboarding-icon1")
            Text("You don't have any task for today")
            Spacer()
        }
    }
    
    var loadingView: some View {
        VStack {
            Spacer()
            ActivityIndicatorView()
                .frame(width: 25, height: 25)
                .background(Rectangle()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 10))
            Spacer()
        }
    }
}
