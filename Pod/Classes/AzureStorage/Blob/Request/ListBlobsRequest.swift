//
//  ListBlobsRequest.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/17/15.
//
//

import Foundation

public extension AzureBlob {
    public class ListBlobsRequest: Request {
        public let method = "GET"
        let container : String
        let maxResults : Int?
        let nextMarker : String?
        
        public typealias Response = Collection<Blob>
        
        public init(container: String, maxResults: Int?, nextMarker: String?) {
            self.container = container
            self.maxResults = maxResults
            self.nextMarker = nextMarker
        }
        
        public func path() -> String {
            return "/\(container)" + "?" + join("&", parameters())
        }
        
        public func body() -> NSData? {
            return nil
        }
        
        public func additionalHeaders() -> [String : String] {
            return [:]
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            return ResponseUtility.responseItems(object, keyPath: "Blobs.Blob")
        }
        
        public func responseTypes() -> Set<String>? {
            return ["application/xml"]
        }
        
        private func parameters() -> [String] {
            var params = [
                "restype=container",
                "comp=list"
            ]
            if let max = maxResults {
                params.append("maxresults=\(max)")
            }
            if let marker = nextMarker {
                params.append("marker=\(marker)")
            }
            return params
        }
        
    }
}
