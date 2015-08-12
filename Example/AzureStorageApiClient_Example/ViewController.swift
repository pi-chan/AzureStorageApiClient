//
//  ViewController.swift
//  AzureStorageApiClient_Example
//
//  Created by Hiromasa Ohno on 8/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import AzureStorageApiClient

class ViewController: UIViewController {
    
    var client : AzureStorage.Client?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        client = AzureStorage.Client(accoutName: Config.Account, accessKey: Config.Key, accountDomain: Config.Domain, useHTTPS: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleResponse<T>(response: Response<T>) {
        switch response {
        case .Success(let wrapper):
            println(wrapper.value)
        case .Failure(let wrapper):
            println(wrapper.value)
        }
    }
    
    func listQueues() {
        let request = AzureStorage.ListQueuesRequest()
        client?.call(request, handler: handleResponse)
    }
    
    func createQueue() {
        let request = AzureStorage.CreateQueueRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }
    
    func deleteQueue() {
        let request = AzureStorage.DeleteQueueRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }
    
    func putMessage() {
        let request = AzureStorage.PutMessagesRequest(queue: "queuename", message: "a message", messageTTL: 3600, visibilityTimeout: 600)
        client?.call(request, handler: handleResponse)
    }
    
    func getMessages() {
        let request = AzureStorage.GetMessagesRequest(queue: "queuename", visibilityTimeout: 600, numberOfMessages: 32)
        client?.call(request, handler: handleResponse)
    }
    
    func peekMessage() {
        let request = AzureStorage.PeekMessagesRequest(queue: "queuename", numberOfMessages: 32)
        client?.call(request, handler: handleResponse)
    }
    
    func deleteMessage() {
        let request = AzureStorage.DeleteMessageRequest(queue: "queuename", messageId: "message-id(UUID)", popReceipt: "pop-receipt")
        client?.call(request, handler: handleResponse)
    }
    
    func clearMessage() {
        let request = AzureStorage.ClearMessagesRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }
    
    func updateMessage() {
        let request = AzureStorage.UpdateMessageRequest(queue: "queuename", message: "new message", messageId: "message-id(UUID)", popReceipt: "pop-receipt", visibilityTimeout: 3600)
        client?.call(request, handler: handleResponse)
    }
}

