//
//  CurrencyConverterInteractorTest.swift
//  CurrencyConverterTests
//
//  Created by Babul Raj on 03/01/23.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyConverterInteractorTest: XCTestCase {

    var sut: CurrencyConverterInteractor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CurrencyConverterInteractor(base: "INR", amount: 5)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testFetchCurrencyRateSuccess() {
        let string =
        "{\"timestamp\":1672344000,\"base\":\"USD\",\"rates\":{\"AED\":3.6726,\"AFN\":87.499985,\"ALL\":107,\"AMD\":393.177474}}"
        let stubbdedData = string.data(using: .utf8)
        let url = URL(string: "https://openexchangerates.org/api/")!
        let studdedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let urlSessionStub = URLSessionStub(data: stubbdedData, response: studdedResponse, error: nil)
        sut.urlSession = urlSessionStub
        let promise = expectation(description: "Completion handler invoked")
        
        sut.fetchCurrencyRate {response in
            switch response {
            case .success(let bool):
                XCTAssertTrue(bool)
            case .failure(let error):
                print(error)            }
           
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    func testFetchCurrencyRateFailure() {
        let string =
        "{\"timestamp\":1672344000,\"base\":\"USD\",\"rates\":{\"AED\":3.6726,\"AFN\":87.499985,\"ALL\":107,\"AMD\":393.177474}}"
        let stubbdedData = string.data(using: .utf8)
        let url = URL(string: "https://openexchangerates.org/api/")!
        let studdedResponse = HTTPURLResponse(url: url, statusCode: 403, httpVersion: nil, headerFields: nil)
        let urlSessionStub = URLSessionStub(data: stubbdedData, response: studdedResponse, error: nil)
        sut.urlSession = urlSessionStub
        let promise = expectation(description: "Completion handler invoked")
        
        sut.fetchCurrencyRate {response in
            switch response {
            case .success(let bool):
                XCTAssertTrue(bool)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
           
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    func testGetCountriesList() {
        let string = "{\"AED\":\"United Arab Emirates Dirham\",\"AFN\":\"Afghan Afghani\"}"
        let stubbdedData = string.data(using: .utf8)
        let url = URL(string: "https://openexchangerates.org/api/")!
        let studdedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let urlSessionStub = URLSessionStub(data: stubbdedData, response: studdedResponse, error: nil)
        sut.urlSession = urlSessionStub
        let promise = expectation(description: "Completion handler invoked")
        sut.getCountriesList(completion: { result in
            switch result {
            case .success(let dict):
                XCTAssertEqual(dict["AFN"], "Afghan Afghani")
                XCTAssertEqual(dict["AED"], "United Arab Emirates Dirham")
            case .failure(let error):
                print(error)
            }
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)

    }

}
