//
//  Fetchable.swift
//  data-repository
//
//  Created by James Langdon on 3/20/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//

import Foundation

protocol DataPath {
    var value: String { get }
}

protocol RestRequestParameters {
    associatedtype Path: DataPath
    associatedtype Body: Encodable
    var path: Path { get set }
    var additional: [String: String]? { get set }
    var body: Body? { get set }
    var httpMethod: HTTPRequestMethod { get set }
    init(path: Path, body: Body?, additional: [String: String]?, httpMethod: HTTPRequestMethod)
}

protocol RestRequestable: Codable {
    associatedtype Input: RestRequestParameters
}

extension Array: RestRequestable where Element: RestRequestable {
    typealias Input = Element.Input
}

extension RESTService {
    func request<Object>(
        for object: Object.Type,
        path: Object.Input.Path,
        body: Object.Input.Body? = nil,
        additional: [String: String]? = nil,
        httpMethod: HTTPRequestMethod = .get) -> RESTRequest where Object: RestRequestable {
        
        let request = Object.Input.init(path: path, body: body, additional: additional, httpMethod: httpMethod)
        return RESTRequest(with: request, from: self.baseUrl)
    }
}
