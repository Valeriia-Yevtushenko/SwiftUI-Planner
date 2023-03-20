//
//  Section.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 08.08.2022.
//

import Foundation

enum SectionType: String {
    case todo = "Todo"
    case resolved = "Resolved"
}

class Section {
    var type: SectionType
    var items: [Document<Todo>]
    
    init(type: SectionType,
         items: [Document<Todo>]) {
        self.type = type
        self.items = items
    }
}
