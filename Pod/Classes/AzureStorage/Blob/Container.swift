//
//  Container.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/13/15.
//
//

import Foundation

public extension AzureBlob {
    public class Container : AzureStorage.Item {
        public var name : String? { get { return rawDictionary.valueForKeyPath("Name") as? String } }
        
        required public init(dictionary: NSDictionary) {
            super.init(dictionary: dictionary)
        }
    }
}
