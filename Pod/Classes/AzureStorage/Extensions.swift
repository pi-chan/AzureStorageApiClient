//
//  ClientBase.swift
//  azurequeue
//
//  Created by Hiromasa Ohno on 2015/08/10.
//  Copyright (c) 2015 CFlat. All rights reserved.
//

import Foundation

extension Dictionary {
    func valueForKey(key: Key, defaultValue: Value) -> Value {
        if let val = self[key] {
            return val
        }
        return defaultValue
    }
    
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}

extension NSURL{
    func parameters() -> Dictionary<String, String>{
        let originalUrl = self.absoluteString!
        let url = originalUrl.componentsSeparatedByString("?")
        if url.count <= 1 {
            return [:]
        }
        
        let core = url[1]
        let params = core.componentsSeparatedByString("&")
        var dict : Dictionary<String, String> = Dictionary<String, String>()
        
        for param in params{
            let keyValue = param.componentsSeparatedByString("=")
            dict[keyValue[0]] = keyValue[1]
        }
        return dict
    }
}
