# AzureStorageApiClient

AzureStorageApiClient is api client library for Microsost Azure Storage in Swift.
This library only supports MS Azure Queue Storage.

## Installation

### Cocoapods

```ruby
pod 'AzureStorageApiClient'
```

## API lists

API with ✅ is supported. I'll continue to implement other APIs.

### [Blob Service REST API](https://msdn.microsoft.com/en-us//library/azure/dd135733.aspx "Blob Service REST API")

- ✅ List Containers
- ✅ Set Blob Service Properties (updating CORS only)
- ✅ Get Blob Service Properties
- Preflight Blob Request
- Get Blob Service Stats
- ✅ Create Container
- Get Container Properties
- Get Container Metadata
- Set Container Metadata
- Get Container ACL
- Set Container ACL
- Lease Container
- ✅ Delete Container
- ✅ List Blobs
- ✅ Put Blob
- ✅ Get Blob
- ✅ Get Blob Properties
- Set Blob Properties
- Get Blob Metadata
- Set Blob Metadata
- ✅ Delete Blob
- Lease Blob
- Snapshot Blob
- Copy Blob
- Abort Copy Blob
- Put Block
- Put Block List
- Get Block List
- Put Page
- Get Page Ranges
- Append Block

### [Queue Service REST API](https://msdn.microsoft.com/en-us/library/azure/dd179363.aspx "Queue Service REST API")

- Set Queue Service Properties
- Get Queue Service Properties
- ✅ List Queues
- Preflight Queue Request
- Get Queue Service Stats
- ✅ Create Queue
- ✅ Delete Queue
- Get Queue Metadata
- Set Queue Metadata
- Get Queue ACL
- Set Queue ACL
- ✅ Put Message
- ✅ Get Messages
- ✅ Peek Messages
- ✅ Delete Message
- ✅ Clear Messages
- ✅ Update Message

## Usage

### Blob Service

```swift
import AzureStorageApiClient

class FooBar {
    private let client = AzureBlob.Client(accoutName: "account", useHTTPS: true, hostName: nil)
    func handleResponse<T>(response: Response<T>) {
        switch response {
        case .Success(let wrapper):
            println(wrapper.value)
        case .Failure(let wrapper):
            println(wrapper.value)
        }
    }

    // Lists all of the containers in a storage account.
    func listContainers() {
        let request = AzureBlob.ListContainersRequest()
        blobClient?.call(request, handler: handleResponse)
    }

    // Creates a new container in a storage account.
    func createContainer() {
        let request = AzureBlob.CreateContainerRequest(container: "containername")
        blobClient?.call(request, handler: handleResponse)
    }

    // Deletes the container and any blobs that it contains.
    func deleteContainer() {
        let request = AzureBlob.DeleteContainerRequest(container: "containername")
        blobClient?.call(request, handler: handleResponse)
    }

    // Creates a new blob or replaces an existing blob within a container.
    func putBlob() {
        if let url = NSURL(string: "https://avatars2.githubusercontent.com/u/3599510?v=3&s=10") {
            let data = NSData(contentsOfURL: url)!
            let request = AzureBlob.PutBlobRequest(container: "containername", name: "file.png", data: data, mimetype: "image/png")
            blobClient?.call(request, handler: handleResponse)
        }
    }

    // Reads or downloads a blob from the Blob service, including its user-defined metadata and system properties.
    func getBlob() {
        let request = AzureBlob.GetBlobRequest(container: "containername", name: "file.png", mimetype: "image/png")
        blobClient?.call(request, handler: handleResponse)
    }

    // Returns all system properties and user-defined metadata on the blob.
    func getBlobProperties() {
        let request = AzureBlob.GetBlobPropertiesRequest(container: "containername", name: "file.png")
        blobClient?.call(request, handler: handleResponse)
    }
}
```

### Queue Service

```swift
import AzureStorageApiClient

class FooBar {
    private let client = AzureQueue.Client(accoutName: "account", accessKey: "key", useHTTPS: true, hostName: nil)

    func handleResponse<T>(response: Response<T>) {
        switch response {
        case .Success(let wrapper):
            println(wrapper.value)
        case .Failure(let wrapper):
            println(wrapper.value)
        }
    }

    // lists all of the queues in a given storage account
    func listQueues() {
        let request = AzureStorage.ListQueuesRequest()
        client?.call(request, handler: handleResponse)
    }

    // creates a queue under the given account
    func createQueue() {
        let request = AzureStorage.CreateQueueRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }

    // permanently deletes the specified queue
    func deleteQueue() {
        let request = AzureStorage.DeleteQueueRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }

    // adds a new message to the back of the message queue
    func putMessage() {
        let request = AzureStorage.PutMessagesRequest(queue: "queuename", message: "a message", messageTTL: 3600, visibilityTimeout: 600)
        client?.call(request, handler: handleResponse)
    }

    // retrieves one or more messages from the front of the queue
    func getMessages() {
        let request = AzureStorage.GetMessagesRequest(queue: "queuename", visibilityTimeout: 600, numberOfMessages: 32)
        client?.call(request, handler: handleResponse)
    }

    // retrieves one or more messages from the front of the queue, but does not alter the visibility of the message
    func peekMessage() {
        let request = AzureStorage.PeekMessagesRequest(queue: "queuename", numberOfMessages: 32)
        client?.call(request, handler: handleResponse)
    }

    // deletes the specified message
    func deleteMessage() {
        let request = AzureStorage.DeleteMessageRequest(queue: "queuename", messageId: "message-id(UUID)", popReceipt: "pop-receipt")
        client?.call(request, handler: handleResponse)
    }

    // deletes all messages from the specified queue
    func clearMessage() {
        let request = AzureStorage.ClearMessagesRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }

    // updates the visibility timeout of a message, the contents of a message
    func updateMessage() {
        let request = AzureStorage.UpdateMessageRequest(queue: "queuename", message: "new message", messageId: "message-id(UUID)", popReceipt: "pop-receipt", visibilityTimeout: 3600)
        client?.call(request, handler: handleResponse)
    }
}
```

## How to run sample app

1. Copy `Example/AzureStorageApiClient_Example/Config.sample.swift` to `Example/AzureStorageApiClient_Example/Config.swift`
- Edit variables in `Example/AzureStorageApiClient_Example/Config.swift`. -> [Microsoft Azure Portal](https://manage.windowsazure.com/)
- Open `Example/AzureStorageApiClient.xcworkspace` and run application.

## Dependencies

- [AFNetworking/AFNetworking](https://github.com/AFNetworking/AFNetworking "AFNetworking/AFNetworking")
- [nicklockwood/XMLDictionary](https://github.com/nicklockwood/XMLDictionary "nicklockwood/XMLDictionary")
- [krzyzanowskim/CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift "krzyzanowskim/CryptoSwift")
- [brynbellomy/Regex](https://github.com/brynbellomy/Regex "brynbellomy/Regex")

## Author

Hiromasa OHno

## License

AzureStorageApiClient is available under the MIT license. See the LICENSE file for more info.
