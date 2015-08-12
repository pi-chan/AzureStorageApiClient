//
//  GetMessagesRequest.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureStorage {
    public class GetMessagesRequest: GetMessagesRequestBase {
        let visibilityTimeout : Int
        
        public init(queue : String, visibilityTimeout : Int, numberOfMessages: Int?) {
            self.visibilityTimeout = visibilityTimeout
            super.init(queue: queue, numberOfMessages: numberOfMessages)
        }
        
        override func parameters() -> [String] {
            var array = super.parameters()
            array.append("visibilitytimeout=\(visibilityTimeout)")
            return array
        }
    }
}
