//
//  CreateContainerRequest.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/13/15.
//
//

import Foundation

public extension AzureBlob {

    public class CreateContainerRequest:  Request {
        
        public enum Accessibility {
            case Private
            case PublicBlob
            case PublicContainer
        }
        
        public let method = "PUT"
        let container : String!
        var accessibility : Accessibility = .Private
        
        public typealias Response = Bool
        
        public init(container: String, accessibility : Accessibility) {
            self.container = container
            self.accessibility = accessibility
        }
        
        public func path() -> String {
            return "/\(container)?restype=container"
        }
        
        public func body() -> NSData? {
            return nil
        }
        
        public func additionalHeaders() -> [String : String] {
            var headers = ["Content-Type": "", "Content-Length": "0"]
            switch accessibility {
            case .Private:
                break
            case .PublicBlob:
                headers["x-ms-blob-public-access"] = "blob"
            case .PublicContainer:
                headers["x-ms-blob-public-access"] = "container"
            }
            return headers
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            return true
        }
        
        public func responseTypes() -> Set<String>? {
            return nil
        }
    }
}
