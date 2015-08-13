//
//  Response.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/10.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public class Wrapper<T> {
    public let value: T
    
    init(_ value: T) {
        self.value = value
    }
}

// adopt Wrapper to avoid "unimplemented IR generation feature non-fixed multi-payload enum layout"
public enum Response<T> {
    case Success(Wrapper<T>)
    case Failure(Wrapper<NSError>)
    
    init(_ value: T) {
        self = .Success(Wrapper(value))
    }
    
    init(_ error: NSError) {
        self = .Failure(Wrapper(error))
    }
}
