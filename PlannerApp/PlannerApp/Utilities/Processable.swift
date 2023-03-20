//
//  Loadable.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 27.07.2022.
//

import Foundation

enum Processable {
    case processing
    case processedNoValue
    case processed
    case failure(String)
}
