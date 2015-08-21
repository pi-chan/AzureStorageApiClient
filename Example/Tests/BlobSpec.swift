// https://github.com/Quick/Quick

import Quick
import Nimble
import AzureStorageApiClient
import BrightFutures

class BlobSpec: QuickSpec {
    let client = AzureBlob.Client(accoutName: Config.Account, accessKey: Config.Key, useHTTPS: true, hostName: nil)
    
    let timeout : NSTimeInterval = 15
    let containerNameForBlob = "containerforblob"
    var testContainerName : String = ""
    var testBlobName : String = ""
    
    func createContainerForBlob(done: ()->Void) {
        let request = AzureBlob.CreateContainerRequest(container: self.containerNameForBlob, accessibility: .Private)
        self.client.future(request)
            .onSuccess { response in
                done()
            }
            .onFailure { error in
                done()
        }
    }
    
    override func spec() {
        
        beforeSuite {
            self.testContainerName = randomStringWithLength(16)
            self.testBlobName = randomStringWithLength(16) + ".txt"
            waitUntil(timeout: self.timeout) { done in
                self.createContainerForBlob(done)
            }
        }

        describe("List Containers") {
            it("Success - get containers without \(self.testContainerName)") {
                waitUntil(timeout: self.timeout) { done in
                    let request = AzureBlob.ListContainersRequest()
                    self.client.future(request)
                        .onSuccess { response in
                            var names = response.items.map { $0.name }.filter { $0 == self.testContainerName }
                            expect(0).to(equal(names.count))
                        }
                        .onFailure { error in
                            println(error)
                            fail()
                        }
                        .onComplete { result in
                            done()
                    }
                }
            }
        }
        
        describe("Create/Delete Container") {
            it("Success") {
                waitUntil(timeout: self.timeout) { done in
                    let request = AzureBlob.CreateContainerRequest(container: self.testContainerName, accessibility: .Private)
                    self.client.future(request)
                        .flatMap { response ->  Future<AzureBlob.ListContainersRequest.Response, NSError> in
                            let req = AzureBlob.ListContainersRequest()
                            return self.client.future(req)
                        }
                        .flatMap { response -> Future<AzureBlob.DeleteContainerRequest.Response, NSError> in
                            var names = response.items.map { $0.name }.filter { $0 == self.testContainerName }
                            expect(1).to(equal(names.count))
                            let req = AzureBlob.DeleteContainerRequest(container: self.testContainerName)
                            return self.client.future(req)
                        }
                        .flatMap { response ->  Future<AzureBlob.ListContainersRequest.Response, NSError> in
                            let req = AzureBlob.ListContainersRequest()
                            return self.client.future(req)
                        }
                        .onSuccess { response in
                            var names = response.items.map { $0.name }.filter { $0 == self.testContainerName }
                            expect(0).to(equal(names.count))
                        }
                        .onFailure { error in
                            println(error)
                            fail()
                        }
                        .onComplete { result in
                            done()
                    }
                }
            }
        }
        
        describe("Put/Delete Blob") {
            it("Success") {
                waitUntil(timeout: self.timeout) { done in
                    let textData = "text\nfile".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                    let request = AzureBlob.PutBlobRequest(container: self.containerNameForBlob, name: self.testBlobName, data: textData, mimetype: "text/html")

                    self.client.future(request)
                        .flatMap { respones -> Future<AzureBlob.ListBlobsRequest.Response, NSError> in
                            let req = AzureBlob.ListBlobsRequest(container: self.containerNameForBlob, maxResults: nil, nextMarker: nil)
                            return self.client.future(req)
                        }.flatMap { response -> Future<AzureBlob.DeleteBlobRequest.Response, NSError> in
                            var names = response.items.map { $0.name }.filter { $0 == self.testBlobName }
                            expect(1).to(equal(names.count))
                            
                            let req = AzureBlob.DeleteBlobRequest(container: self.containerNameForBlob, name: self.testBlobName)
                            return self.client.future(req)
                        }.flatMap { respones -> Future<AzureBlob.ListBlobsRequest.Response, NSError> in
                            let req = AzureBlob.ListBlobsRequest(container: self.containerNameForBlob, maxResults: nil, nextMarker: nil)
                            return self.client.future(req)
                        }.onSuccess { response in
                            var names = response.items.map { $0.name }.filter { $0 == self.testBlobName }
                            expect(0).to(equal(names.count))
                        }.onFailure { error in
                            println(error)
                            fail()
                        }.onComplete { result in
                            done()
                    }
                }
            }
        }
    }
}
