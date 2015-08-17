//
//  Queue.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/07/30.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureQueue {
    public class Queue : AzureStorage.Item {
        public var name : String? { get { return rawDictionary.valueForKeyPath("Name") as? String } }
        
        override init(dictionary: NSDictionary) {
            super.init(dictionary: dictionary)
        }
    }
}
