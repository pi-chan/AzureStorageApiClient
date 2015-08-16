//
//  AzureStorageRequetSerializer.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/13/15.
//
//

import AFNetworking

class AzureStorageRequetSerializer: AFHTTPRequestSerializer {

    override func requestBySerializingRequest(request: NSURLRequest!, withParameters parameters: AnyObject!, error: NSErrorPointer) -> NSURLRequest! {
        var request = super.requestBySerializingRequest(request, withParameters: parameters, error: error)
        var mutableRequest: NSMutableURLRequest = request.mutableCopy() as! NSMutableURLRequest
        mutableRequest.HTTPBody = parameters as? NSData
        return mutableRequest
    }
}
