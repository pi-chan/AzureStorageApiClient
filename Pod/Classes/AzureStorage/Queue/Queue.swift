//
//  Queue.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/07/30.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureQueue {
    public class Queue {
        public let name: String!
        
        init?(dictionary: NSDictionary) {
            name = dictionary["Name"] as? String
            if name == nil {
                return nil
            }
        }
    }
}
