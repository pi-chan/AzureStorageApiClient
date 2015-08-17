//
//  Collection.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/17/15.
//
//

import Foundation

public class Collection<T> {
    let items : [T]
    let nextMarker : String?
    
    init(items: [T], nextMarker: String?) {
        self.items = items
        self.nextMarker = nextMarker
    }
}
