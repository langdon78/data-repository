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

// MARK: - Rest Requestable
extension Todo: RestRequestable {
    // Request Parameters
    enum Path: DataPath {
        case todos(id: String? = nil)
        
        var value: String {
            switch self {
            case .todos(let id): return "todos/\(id ?? "")"
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

// MARK: - File Requestable
extension Todo: FileRequestable {
    struct File: DataFile {
        var fileName: String = "sample-todos"
        var fileExtension: String = "json"
        var fullName: String {
            return "\(fileName).\(fileExtension)"
        }
    }
    
    struct FileInput: FileRequestParameters {
        var path: Path?
        var file: File
    }
}
