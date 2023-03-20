//
//  HomeView.swiftb
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 04.08.2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    init() {
        _viewModel = .init(wrappedValue: HomeViewModel())
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack {
                    calendarButton
                    datesCollection
                    
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
                }
                
                addButton
                
                Divider().background(.secondary)
            }
            .background(Color(UIColor.secondarySystemBackground))
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.getTodos()
            }
        }
    }
}

private extension HomeView {
    var datesCollection: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.dates, id: \.self) { date in
                        DateView(date: date)
                            .onTapGesture {
                                viewModel.selectedDate = date
                            }
                    }
                }
            }
        }
        .onAppear {
            viewModel.getNextWeekDates()
        }
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
                            }.onDrag {
                                NSItemProvider(object: item.documentId as NSString)
                            }
                        }
                        .onInsert(of: [.text]) { index, itemProviders in
                            performInsert(itemProviders: itemProviders,
                                          section: section.type)
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
    
    var addButton: some View {
        HStack {
            NavigationLink(destination: CreateTodoView()) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .padding(10)
            }
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(.infinity)
            .padding()
            
            Spacer()
        }
        .padding(.leading, 20.0)
    }
    
    var calendarButton: some View {
        HStack {
            Spacer()
            NavigationLink(destination: CalendarView(calendar: Calendar(identifier: .gregorian))) {
                HStack {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            }
        }
        .padding(.trailing, 20.0)
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

extension HomeView {
    func performInsert(itemProviders: [NSItemProvider], section: SectionType) {
        let isResolved: Bool
        
        switch section {
        case .todo:
            isResolved = false
        case .resolved:
            isResolved = true
        }
        
        for itemProvider in itemProviders {
            
            itemProvider.loadObject(ofClass: String.self) { documentId, _ in
                guard let documentId = documentId else {
                    return
                }
                
                viewModel.updateStatus(documentId, isResolved: isResolved)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
