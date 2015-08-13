//
//  Request.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/10.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public protocol Request {
    var method: String { get }
    
    typealias Response: Any
    
    func path() -> String
    func additionalHeaders() -> [String:String]
    func body() -> String
    func convertJSONObject(object: AnyObject?) -> Response?
}
