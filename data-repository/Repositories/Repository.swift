//
//  JSONPlaceholderRepo.swift
//  data-repository
//
//  Created by James Langdon on 3/20/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//


import Foundation

class Repository {
    private static let restPlaceholder = RestPlaceholderRepository(dataSource: RESTService(baseUrl: RestPlaceholderRepository.baseUrl))
    private static let localPlaceholder = LocalPlaceholderRepository(dataSource: LocalFileService())
    
    var lastUpdated: Date? = nil
    var needsCurrentData: Bool {
        guard let lastUpdated = lastUpdated else { return true }
        return lastUpdated.addingTimeInterval(5) < Date()
    }
    
    // MARK: Timer based switch
    func placeholder(forceRefresh: Bool = false) -> any PlaceholderRepository {
        if needsCurrentData || forceRefresh {
            lastUpdated = Date()
            return Repository.restPlaceholder
        }
        return Repository.localPlaceholder
    }
    
    // MARK: - Failover switch
    struct Placeholder: PlaceholderRepository {
        func todos(_ completion: @escaping (Result<[Todo], ResponseError>) -> Void) {
            Repository.restPlaceholder.todos { result in
                switch result {
                case .success(let todos): completion(.success(todos))
                case .failure(_):
                    Repository.localPlaceholder.todos(completion)
                }
            }
        }
        
        func todo(for id: Int, _ completion: @escaping (Result<Todo, ResponseError>) -> Void) {
            Repository.restPlaceholder.todo(for: id) { result in
                switch result {
                case .success(let todo): completion(.success(todo))
                case .failure(_):
                    Repository.localPlaceholder.todo(for: id, completion)
                }
            }
        }
    }
}
