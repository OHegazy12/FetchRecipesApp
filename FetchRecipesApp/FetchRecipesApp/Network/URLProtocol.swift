//
//  URLProtocol.swift
//  FetchRecipesApp
//
//  Created by Omar Hegazy on 12/13/24.
//

import SwiftUI

class URLProtocolMock: URLProtocol {
    static var testURLs = [String: (Data, URLResponse)]()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return testURLs[request.url!.absoluteString] != nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let response = URLProtocolMock.testURLs[request.url!.absoluteString] {
            self.client?.urlProtocol(self, didReceive: response.1, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: response.0)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}

