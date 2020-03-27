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

/// AnyPlaceholderRepository exists to perform type erasure
/// for each data source. This is meant to be subclassed.
class AnyPlaceholderRepository<Source>: PlaceholderRepository where Source: DataSource {
    func todos(_ completion: @escaping (Result<[Todo], ResponseError>) -> Void) {
        completion(.failure(unimplementedMethod(for: #function)))
    }

    func todo(for id: Int, _ completion: @escaping (Result<Todo, ResponseError>) -> Void) {
        completion(.failure(unimplementedMethod(for: #function)))
    }
    
    var dataSource: Source
    
    init(dataSource: Source) {
        self.dataSource = dataSource
    }
    
    private func unimplementedMethod(for method: String) -> ResponseError {
        return .unimplementedMethod("\(method) for \(dataSource)")
    }
}

// MARK: - RestPlaceholderRepository
class RestPlaceholderRepository: AnyPlaceholderRepository<RESTService> {
    static var baseUrl = URL(string: "https://jsonplaceholder.typicode.com")!
    
    override func todos(_ completion: @escaping (Result<[Todo], ResponseError>) -> Void) {
        let request = dataSource.request(for: [Todo].self, path: .todos())
        dataSource.execute(request, completionHandler: completion)
    }
    
    override func todo(for id: Int, _ completion: @escaping (Result<Todo, ResponseError>) -> Void) {
        let request = dataSource.request(for: [Todo].self, path: .todos(id: String(id)))
        dataSource.execute(request, completionHandler: completion)
    }
}

// MARK: - LocalPlaceholderRepository
class LocalPlaceholderRepository: AnyPlaceholderRepository<LocalFileService> {
    override func todos(_ completion: @escaping Response<[Todo]>) {
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
