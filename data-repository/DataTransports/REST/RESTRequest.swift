//
//  RESTRequestor.swift
//  data-repository
//
//  Created by James Langdon on 3/20/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//

import Foundation

/// Object is passed into a RESTService DataSource
/// in order to form a URLRequest for remote data
/// access. Data objects must confrom to Fetchable
/// which allows parameters to be set and synthesized
/// encoding/decoding of parameters and data responses
struct RESTRequest: Requestable {
    var baseUrl: URL
    typealias Request = URLRequest
    var request: Request
    /// Initialize a RESTRequest object
    /// - Parameters:
    ///   - params: The parameters for a Fetchable data object
    ///   - baseUrl: Base URL of request
    ///   - httpHeaders: Headers to be passed in HTTP request
    init<DataItem>(with params: DataItem,
                   from baseUrl: URL,
                   httpHeaders: [String: String] = [:]) where DataItem: RestRequestParameters {
        self.baseUrl = baseUrl
        self.baseUrl.appendPathComponent(params.path.value)
        var urlRequest = RESTRequest.request(for: self.baseUrl, headers: httpHeaders, body: params.body, queryItems: params.additional)
        urlRequest.httpMethod = params.httpMethod.rawValue
        self.request = urlRequest
    }
    
    private static func request<Encoded>(for url: URL, headers: [String: String]?, body: Encoded?, queryItems: [String: String]?) -> Request where Encoded: Encodable {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = queryItems?.map { URLQueryItem(name: $0.key, value: $0.value) }
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.allHTTPHeaderFields = headers
        if let body = body {
            urlRequest.httpBody = encode(from: body)
        }
        return urlRequest
    }
    
    private static func request(for url: URL, headers: [String: String]? = nil) -> Request {
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
    
    private static func encode<T>(from object: T) -> Data? where T: Encodable {
        do {
            let encoded = try JSONEncoder().encode(object)
            return encoded
        } catch {
            print(error)
            return nil
        }
    }
}

