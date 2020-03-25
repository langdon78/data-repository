//
//  LocalFileResponse.swift
//  data-repository
//
//  Created by James Langdon on 3/24/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//

import Foundation

final class LocalFileService: DataSource  {
    var baseUrl: URL
    
    typealias Request = LocalFileRequest
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    func execute<Decoded>(_ request: LocalFileRequest, completionHandler: @escaping (Result<Decoded, ResponseError>) -> Void) where Decoded : Decodable {
        read(from: request.request) { result in
            switch result {
            case .success(let data):
                guard let decoded: Decoded = LocalFileService.decode(for: data) else {
                    completionHandler(.failure(ResponseError.unableToParseResponse))
                    return
                }
                completionHandler(.success(decoded))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func fileExists(at path: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
    
    func read(from url: URL, completionHandler: @escaping Response<Data>) {
        guard fileExists(at: url.path) else {
            completionHandler(.failure(.dataFileDoesNotExist(url.lastPathComponent)))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            completionHandler(.success(data))
        } catch {
            completionHandler(.failure(.network(error)))
        }
    }
    
    // Codable helper methods
    static private func decode<T>(for data: Data) -> T? where T: Decodable {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            print(error) // log error to console
            return nil
        }
    }
}
