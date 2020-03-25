//
//  JSONPlaceholderRepo.swift
//  data-repository
//
//  Created by James Langdon on 3/20/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//


import Foundation

protocol DataAccess {
    func todos(_ completion: @escaping (Result<[Todo], ResponseError>) -> Void)
}

class PlaceholderDataAccess<Source>: DataAccess where Source: DataSource {
    func todos(_ completion: @escaping (Result<[Todo], ResponseError>) -> Void) {
        dataSource.todos(completion)
    }
    
    var dataSource: Source
    
    init(dataSource: Source) {
        self.dataSource = dataSource
    }
}

class PlaceholderRepository {
    // MARK: Constants
    static var baseUrl = URL(string: "https://jsonplaceholder.typicode.com")!
    var forceRefresh = false
    var lastUpdated: Date? = nil
    var needsCurrentData: Bool {
        guard let lastUpdated = lastUpdated else { return true }
        return lastUpdated.addingTimeInterval(5) < Date()
    }
    
    var dataAccess: DataAccess {
        get {
            if needsCurrentData || forceRefresh {
                lastUpdated = Date()
                return PlaceholderDataAccess(dataSource: RESTService(baseUrl: PlaceholderRepository.baseUrl))
            }
            return PlaceholderDataAccess(dataSource: LocalFileService(baseUrl: PlaceholderRepository.baseUrl))
        }
    }
    
    func todos(forceRefresh: Bool = false, _ completion: @escaping (Result<[Todo], ResponseError>) -> Void) {
        self.forceRefresh = forceRefresh
        dataAccess.todos(completion)
    }
    
}

extension RESTService {
    func todos(_ completion: @escaping (Result<[Todo], ResponseError>) -> Void) {
        let request = self.request(for: [Todo].self, path: .todos)
        self.execute(request, completionHandler: completion)
    }
}

extension LocalFileService {
    func todos(_ completion: @escaping Response<[Todo]>) {
        let bundle = Bundle.main
        if let url = bundle.url(forResource: "sample-todos", withExtension: "json") {
            let request = LocalFileRequest(request: url)
            self.execute(request, completionHandler: completion)
        }
    }
}
