//
//  DataSource.swift
//  data-repository
//
//  Created by James Langdon on 3/20/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//

import Foundation

typealias Response<T> = (Result<T, ResponseError>) -> Void

protocol Requestable {
    associatedtype Request
    var request: Request { get set }
}

/// Defines a contract for a general data source
/// Requires a Requestor type to allow passing
/// request parameters for CRUD operations
/// with Codable conforming data types
protocol DataSource {
    associatedtype Request: Requestable
//    associatedtype Decoded: Fetchable
    /// Method to retrieve data from a given location
    /// asynchronously returning decoded data objects
    /// - Parameters:
    ///   - requestor: Conforms to Requestable protocol and provides
    ///     data source the ability to access data
    ///   - completionHandler: Handler for Result, if successful
    ///     returns decoded data object otherwise an error
    func execute<Decoded>(_ request: Request, completionHandler: @escaping Response<Decoded>) where Decoded: Decodable
}

// TODO: Make errors more specific
enum ResponseError: Error {
    case missingData
    case unableToParseResponse
    case network(Error)
    case dataFileDoesNotExist(String)
    case unimplementedMethod(String)
}
