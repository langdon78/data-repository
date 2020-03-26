//
//  Repository.swift
//  data-repository
//
//  Created by James Langdon on 3/25/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//

import Foundation

protocol Repository {
    func todos(_ completion: @escaping (Result<[Todo], ResponseError>) -> Void)
    func todo(for id: Int, _ completion: @escaping (Result<Todo, ResponseError>) -> Void)
}

class AnyRepository<Source>: Repository where Source: DataSource {
    func todos(_ completion: @escaping (Result<[Todo], ResponseError>) -> Void) {
        dataSource.todos(completion)
    }

    func todo(for id: Int, _ completion: @escaping (Result<Todo, ResponseError>) -> Void) {
        dataSource.todo(for: id, completion)
    }
    
    var dataSource: Source
    
    init(dataSource: Source) {
        self.dataSource = dataSource
    }
}
