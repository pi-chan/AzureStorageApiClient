//
//  ClientBase.swift
//  azurequeue
//
//  Created by Hiromasa Ohno on 2015/08/10.
//  Copyright (c) 2015 CFlat. All rights reserved.
//

import Foundation

public class Box<T> {
    public let value: T
    
    init(_ value: T) {
        self.value = value
    }
}

// adopt Box to avoid "unimplemented IR generation feature non-fixed multi-payload enum layout"
public enum Response<T> {
    case Success(Box<T>)
    case Failure(Box<NSError>)
    
    init(_ value: T) {
        self = .Success(Box(value))
    }
    
    init(_ error: NSError) {
        self = .Failure(Box(error))
    }
}