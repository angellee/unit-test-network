// this test uses the following pod
// https://github.com/dasdom/DHURLSessionStub/blob/master/Pod/Classes/DHURLSessionMock.swift


import XCTest

class NetworkTests: XCTestCase {    
    var sessionMock: URLSessionMock!
    let url = URL(string: "/api/someData")
    
    override func setUp() {
        super.setUp()        
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 404, httpVersion: nil, headerFields: nil)
        sessionMock = URLSessionMock(data: nil, response: urlResponse, error: NetworkError.NotFound)
    }
    
    func testNetworkNotFound() {
        let promise = expectation(description: "Status code: 404")
        
        var responseError: Error?
        var statusCode: Int?
        let url = URL(string: "/api/someData")
        let dataTask = sessionMock.dataTask(with: url!) {
            data, response, error in
            if let error = error {
                responseError = error
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 404 {
                    statusCode = httpResponse.statusCode
                    promise.fulfill()
                }
            }
        }
        dataTask?.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(responseError)
        XCTAssertEqual(statusCode, 404)
    }
}
