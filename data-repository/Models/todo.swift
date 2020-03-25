//
//  todo.swift
//  data-repository
//
//  Created by James Langdon on 3/20/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//

import Foundation

struct Todo: Decodable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}

extension Todo: RestRequestable {
    // Request Parameters
    enum Path: DataPath {
        case todos
        
        var value: String {
            switch self {
            case .todos: return "todos"
            }
        }
    }
    
    struct Body: Encodable {}
    
    struct Input: RestRequestParameters {
        var path: Path
        var body: Body?
        var additional: [String : String]?
        var httpMethod: HTTPRequestMethod
    }
}
