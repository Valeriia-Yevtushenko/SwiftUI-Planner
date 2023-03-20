//
//  StorageService.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 30.08.2022.
//

import Foundation
import KeychainSwift

final class StorageService {
    private let keychain = KeychainSwift()
}

extension StorageService: StorageServiceProtocol {
    func remove(key: String) {
        keychain.delete(key)
    }
    
    func set<T: Codable>(_ data: T, key: String) {
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(data) else {
            return
        }
        
        keychain.set(data, forKey: key)
    }
    
    func get<T: Codable>(key: String) -> T? {
        let decoder = JSONDecoder()
        
        guard let tokenData = keychain.getData(key), let token = try? decoder.decode(T.self, from: tokenData) else {
            return nil
        }
        
        return token
    }
}
