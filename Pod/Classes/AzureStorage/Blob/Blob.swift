//
//  Blob.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/17/15.
//
//

import Foundation

public extension AzureBlob {
    public class Blob : AzureStorage.Item {
        public var name : String? { get { return rawDictionary.valueForKeyPath("Name") as? String } }
        public var contentType : String? { get { return rawDictionary.valueForKeyPath("Properties.Content-Type") as? String } }
        
        required public init(dictionary: NSDictionary) {
            super.init(dictionary: dictionary)
        }
    }
}
