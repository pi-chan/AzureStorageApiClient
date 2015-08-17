//
//  Item.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/17/15.
//
//

import Foundation

extension AzureStorage {
    public class Item {
        let rawDictionary: NSMutableDictionary
        init(dictionary: NSDictionary) {
            rawDictionary = NSMutableDictionary(dictionary: dictionary)
        }
        
        public func prop(key: String) -> String? {
            return rawDictionary[key] as? String
        }
    }
}