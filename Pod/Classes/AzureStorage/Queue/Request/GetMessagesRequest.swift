//
//  GetMessagesRequest.swift
//  azurequeue
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 CFlat. All rights reserved.
//

import Foundation

public extension AzureStorage {
    public class GetMessagesRequest: FetchMessagesRequest {
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
