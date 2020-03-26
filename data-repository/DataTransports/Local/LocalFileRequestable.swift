//
//  LocalFileRequestable.swift
//  data-repository
//
//  Created by James Langdon on 3/24/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//

import Foundation

protocol DataFile {
    var fileName: String { get }
    var fileExtension: String { get }
    var fullName: String { get }
}

protocol FileRequestParameters {
    associatedtype Path: DataPath
    associatedtype File: DataFile
    var path: Path? { get set }
    var file: File { get set }
    init(path: Path?, file: File)
}

protocol FileRequestable: Codable {
    associatedtype FileInput: FileRequestParameters
}

extension Array: FileRequestable where Element: FileRequestable {
    typealias FileInput = Element.FileInput
}

extension LocalFileService {
    func request<Object>(
        for object: Object.Type,
        path: Object.FileInput.Path?,
        file: Object.FileInput.File) -> LocalFileRequest? where Object: FileRequestable {
        
        let request = Object.FileInput.init(path: path, file: file)
        return LocalFileRequest(params: request)
    }
}
