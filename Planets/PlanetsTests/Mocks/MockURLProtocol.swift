//
//  MockURLProtocol.swift
//  PlanetsTests
//
//  Created by Andrew on 07/03/21.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        guard let handler = MockURLProtocol.requestHandler else {
            return
        }
        
        let (response, data, error) = handler(request)
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }

        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
        
    }
    
    override func stopLoading() {
        
    }
}
