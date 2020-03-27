//
//  JSONPlaceholderRepo.swift
//  data-repository
//
//  Created by James Langdon on 3/20/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//


import Foundation

class Repository {
    private static let restPlaceholder = RestPlaceholderRepository(dataSource: RESTService(baseUrl: RestPlaceholderRepository.baseUrl))
    private static let localPlaceholder = LocalPlaceholderRepository(dataSource: LocalFileService())
    
    var lastUpdated: Date? = nil
    var needsCurrentData: Bool {
        guard let lastUpdated = lastUpdated else { return true }
        return lastUpdated.addingTimeInterval(5) < Date()
    }
    
    func placeholder(forceRefresh: Bool = false) -> PlaceholderRepository {
        if needsCurrentData || forceRefresh {
            lastUpdated = Date()
            return Repository.restPlaceholder
        }
        return Repository.localPlaceholder
    }
}
