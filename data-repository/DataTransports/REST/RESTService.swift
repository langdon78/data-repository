//
//  RESTService.swift
//  data-repository
//
//  Created by James Langdon on 3/20/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//

import Foundation

enum HTTPRequestMethod: String {
    case post
    case get
    case put
    case delete
}

/// Fetch resource from REST web service
final class RESTService: DataSource  {
    var baseUrl: URL
    var headers: [String: String]?
    
    typealias Request = RESTRequest
    
    init(baseUrl: URL, headers: [String: String]? = nil) {
        self.baseUrl = baseUrl
        self.headers = headers
    }
    
    // MARK: Public Methods
    
    /// Returns data from a HTTP REST request.
    /// Data must conform to Codable and will be
    /// automatically synthesized upon retrieval
    /// - Parameters:
    ///   - requestor: RESTRequestor object that contains fully formed
    ///                HTTP request
    ///   - completionHandler: Returns Result wrapped, decoded Fetchable data object
    public func execute<Decoded>(_ request: Request, completionHandler: @escaping Response<Decoded>) where Decoded: Decodable {
        retrieve(from: request.request) { result in
            switch result {
            case .success(let data):
                guard let entities: Decoded = RESTService.decode(for: data) else {
                    completionHandler(.failure(ResponseError.unableToParseResponse))
                    return
                }
                completionHandler(.success(entities))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // MARK: Private Methods
    private func retrieve(from urlRequest: URLRequest, completionHandler: @escaping Response<Data>) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let networkError = error {
                completionHandler(.failure(.network(networkError)))
                print("Network error from \(#function): \(networkError).")
            }
            guard let data = data else {
                completionHandler(.failure(ResponseError.missingData))
                return
            }
            completionHandler(.success(data))
        }).resume()
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
