//
//  Repository.swift
//  data-repository
//
//  Created by James Langdon on 3/25/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//

import Foundation

// MARK: - PlaceholderRepository
protocol PlaceholderRepository {
    func todos(_ completion: @escaping (Result<[Todo], ResponseError>) -> Void)
    func todo(for id: Int, _ completion: @escaping (Result<Todo, ResponseError>) -> Void)
}

// MARK: - RestPlaceholderRepository
class RestPlaceholderRepository: PlaceholderRepository {
    static var baseUrl = URL(string: "https://jsonplaceholder.typicode.com")!
    
    var dataSource: RESTService
    
    init(dataSource: RESTService) {
        self.dataSource = dataSource
    }
    
    func todos(_ completion: @escaping (Result<[Todo], ResponseError>) -> Void) {
        let request = dataSource.request(for: [Todo].self, path: .todos())
        dataSource.execute(request, completionHandler: completion)
    }
    
    func todo(for id: Int, _ completion: @escaping (Result<Todo, ResponseError>) -> Void) {
        let request = dataSource.request(for: [Todo].self, path: .todos(id: String(id)))
        dataSource.execute(request, completionHandler: completion)
    }
}

// MARK: - LocalPlaceholderRepository
class LocalPlaceholderRepository: PlaceholderRepository {
    func todo(for id: Int, _ completion: @escaping (Result<Todo, ResponseError>) -> Void) {
        print("local todo called")
    }
    
    var dataSource: LocalFileService
    
    init(dataSource: LocalFileService) {
        self.dataSource = dataSource
    }
    
    func todos(_ completion: @escaping Response<[Todo]>) {
        let defaultFile = Todo.File()
        let request = dataSource.request(for: [Todo].self,
                                   path: nil,
                                   file: defaultFile)
        guard let fileRequest = request else {
            completion(.failure(.dataFileDoesNotExist("\(defaultFile.fullName)")))
            return
        }
        dataSource.execute(fileRequest, completionHandler: completion)
    }
}
