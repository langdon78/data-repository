//
//  JSONPlaceholderRepo.swift
//  data-repository
//
//  Created by James Langdon on 3/20/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//


import Foundation

class PlaceholderRepository {
    // MARK: Constants
    static var baseUrl = URL(string: "https://jsonplaceholder.typicode.com")!
    var forceRefresh = false
    var lastUpdated: Date? = nil
    var needsCurrentData: Bool {
        guard let lastUpdated = lastUpdated else { return true }
        return lastUpdated.addingTimeInterval(5) < Date()
    }
    
    var repository: Repository {
        get {
            if needsCurrentData || forceRefresh {
                lastUpdated = Date()
                return AnyRepository(dataSource: RESTService(baseUrl: PlaceholderRepository.baseUrl))
            }
            return AnyRepository(dataSource: LocalFileService())
        }
    }
    
    func todos(forceRefresh: Bool = false, _ completion: @escaping (Result<[Todo], ResponseError>) -> Void) {
        self.forceRefresh = forceRefresh
        repository.todos(completion)
    }
    
    func todo(for id: Int, forceRefresh: Bool = false, _ completion: @escaping (Result<Todo, ResponseError>) -> Void) {
        self.forceRefresh = forceRefresh
        repository.todo(for: id, completion)
    }
    
}

extension RESTService {

    func todos(_ completion: @escaping (Result<[Todo], ResponseError>) -> Void) {
        let request = self.request(for: [Todo].self, path: .todos())
        self.execute(request, completionHandler: completion)
    }
    
    func todo(for id: Int, _ completion: @escaping (Result<Todo, ResponseError>) -> Void) {
        let request = self.request(for: [Todo].self, path: .todos(id: String(id)))
        self.execute(request, completionHandler: completion)
    }

}

extension LocalFileService {

    func todos(_ completion: @escaping Response<[Todo]>) {
        let defaultFile = Todo.File()
        let request = self.request(for: [Todo].self,
                                   path: nil,
                                   file: defaultFile)
        guard let fileRequest = request else {
            completion(.failure(.dataFileDoesNotExist("\(defaultFile.fullName)")))
            return
        }
        self.execute(fileRequest, completionHandler: completion)
    }
    
    func todo(for id: Int, _ completion: @escaping (Result<Todo, ResponseError>) -> Void) {
        completion(.failure(.dataFileDoesNotExist("Not implemented")))
    }

}
