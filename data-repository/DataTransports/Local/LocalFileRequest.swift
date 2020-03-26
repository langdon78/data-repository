//
//  LocalFileRequest.swift
//  data-repository
//
//  Created by James Langdon on 3/24/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//

import Foundation

struct LocalFileRequest: Requestable {
    typealias Request = URL
    
    var request: Request
    
    init?<DataItem>(params: DataItem) where DataItem: FileRequestParameters {
        let bundle = Bundle.main
        if let url = bundle.url(forResource: params.file.fileName, withExtension: params.file.fileExtension) {
            self.request = url
            return
        }
        return nil
    }
}
