//
//  Client.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/07/30.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation
import AFNetworking
import CryptoSwift
import BrightFutures

extension AzureStorage {
   
    public class Client {
        let scheme : String!
        let key : String!
        let name : String!
        let hostName : String?
        let defaultHost = "core.windows.net"
        
        public init(accoutName: String, accessKey: String, useHTTPS: Bool, hostName: String?) {
            scheme = useHTTPS ? "https" : "http"
            key = accessKey
            name = accoutName
            self.hostName = hostName
        }
        
        public func future<T: Request>(request: T) -> Future<T.Response, NSError> {
            let promise = Promise<T.Response, NSError>()
            let handleError = { () -> Void in
                let userInfo = [NSLocalizedDescriptionKey: "unresolved error occurred."]
                let error = NSError(domain: "WebAPIErrorDomain", code: 0, userInfo: userInfo)
                promise.failure(error)
            }
            
            let success = { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                let statusCode = (task.response as? NSHTTPURLResponse)?.statusCode
                switch (statusCode, request.convertResponseObject(responseObject)) {
                case (.Some(200..<300), .Some(let response)):
                    promise.success(response)
                default:
                    handleError()
                }
            }
            
            let headSuccess = { (task: NSURLSessionDataTask!) -> Void in
                let response = task.response as? NSHTTPURLResponse
                switch (response?.statusCode, request.convertResponseObject(response?.allHeaderFields)) {
                case (.Some(200..<300), .Some(let response)):
                    promise.success(response)
                default:
                    handleError()
                }
            }
            
            let failure = { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                promise.failure(error)
            }
            
            callImpl(request, success: success, headSuccess: headSuccess, failure: failure)
            return promise.future
        }
        
        public func call<T: Request>(request: T, handler: (Response<T.Response>) -> Void = { r in }) {
            
            let handleError = { () -> Void in
                let userInfo = [NSLocalizedDescriptionKey: "unresolved error occurred."]
                let error = NSError(domain: "WebAPIErrorDomain", code: 0, userInfo: userInfo)
                handler(Response(error))
            }
            
            let success = { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                let statusCode = (task.response as? NSHTTPURLResponse)?.statusCode
                switch (statusCode, request.convertResponseObject(responseObject)) {
                case (.Some(200..<300), .Some(let response)):
                    handler(Response(response))
                default:
                    handleError()
                }
            }
            
            let headSuccess = { (task: NSURLSessionDataTask!) -> Void in
                let response = task.response as? NSHTTPURLResponse
                switch (response?.statusCode, request.convertResponseObject(response?.allHeaderFields)) {
                case (.Some(200..<300), .Some(let response)):
                    handler(Response(response))
                default:
                    handleError()
                }
            }
            
            let failure = { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                handler(Response(error))
            }
            
            callImpl(request, success: success, headSuccess: headSuccess, failure: failure)
        }

        internal func service() -> String {
            return ""
        }
        
        private func host() -> String {
            if let hostname = hostName {
                return hostname
            } else {
                return "\(name).\(service()).\(defaultHost)"
            }
        }
        
        private func callImpl<T: Request>(request: T,
            success: (NSURLSessionDataTask!, AnyObject!) -> Void,
            headSuccess: (NSURLSessionDataTask!) -> Void,
            failure: (NSURLSessionDataTask!, NSError!) -> Void) {
                let url = scheme + "://" + host() + request.path()
                let manager = configuredManager(request)
                
                switch request.method {
                case "HEAD":
                    manager.HEAD(url, parameters: nil, success: headSuccess, failure: failure)
                case "GET":
                    manager.GET(url, parameters: nil, success: success, failure: failure)
                case "POST":
                    manager.POST(url, parameters: request.body(), success: success, failure: failure)
                case "PUT":
                    manager.PUT(url, parameters: request.body(), success: success, failure: failure)
                case "DELETE":
                    manager.DELETE(url, parameters: nil, success: success, failure: failure)
                default:
                    break
                }
        }
        
        private func configuredManager<T: Request>(request: T) -> AFHTTPSessionManager {
            let url = scheme + "://" + host() + request.path()
            
            var headers = Dictionary<String, String>()
            headers["x-ms-date"] = dateString()
            headers["x-ms-version"] = "2014-02-14"
            headers.merge(request.additionalHeaders())
            
            var signer = Signer(name: name, key: key)
            var sign = signer.signature(request.method, uri: url, headers: headers)
            headers["Authorization"] = "SharedKey \(name):\(sign)"
            
            var manager = AFHTTPSessionManager()
            if let data = request.body() {
                manager.requestSerializer = AzureStorageRequetSerializer()
            }
            for (key, value) in headers {
                manager.requestSerializer.setValue(value, forHTTPHeaderField: key)
            }
            manager.responseSerializer = AFHTTPResponseSerializer()
            manager.responseSerializer.acceptableContentTypes = request.responseTypes()
            return manager
        }
        
        private func dateString() -> String {
            let date = NSDate()
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            formatter.timeZone = NSTimeZone(name: "UTC")
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
            return formatter.stringFromDate(date)
        }
    }
}