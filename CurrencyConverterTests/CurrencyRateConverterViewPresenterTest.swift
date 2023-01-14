//
//  CurrencyRateConverterViewPresenterTest.swift
//  CurrencyConverterTests
//
//  Created by Babul Raj on 03/01/23.
//
// pROTOCOLS 
import XCTest
@testable import CurrencyConverter

class CurrencyConverterInteractorMockForSuccess: CurrencyConverterInteractorProtocol {
    func getCountriesList(completion: @escaping (Result<[String : String], Error>) -> ()) {
        DispatchQueue.main.async {
            completion(.success(["INR":"Indian Rupee", "GBR":"Britain Pound" ]))
        }
    }
    
    func getCurrencyRate(for currency: String, completion: @escaping (Result<CurrencyConverter.CurrencyModel, Error>) -> ()) {
        let currencyModel = CurrencyModel(base: "USD", timestamp: 2, rates: ["INR":83, "GBR":100])
        DispatchQueue.main.async {
            completion(.success(currencyModel))
        }
    }
}

class CurrencyConverterInteractorMockForFailure: CurrencyConverterInteractorProtocol {
    func getCountriesList(completion: @escaping (Result<[String : String], Error>) -> ()) {
        DispatchQueue.main.async {
            completion(.failure(ApiError.badURL))
        }
    }
    
    func getCurrencyRate(for currency: String, completion: @escaping (Result<CurrencyConverter.CurrencyModel, Error>) -> ()) {
        let currencyModel = CurrencyModel(base: "USD", timestamp: 2, rates: ["INR":83, "GBR":100])
        DispatchQueue.main.async {
            completion(.success(currencyModel))
        }
    }
}

final class CurrencyRateConverterViewPresenterTest: XCTestCase {

    var sut: CurrencyRateConverterViewPresenter!
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testStartSuccess() {
        let promise = expectation(description: "start Success")
        sut = CurrencyRateConverterViewPresenter()
        sut.interactor = CurrencyConverterInteractorMockForSuccess()
        sut.start({_ in
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
        XCTAssert(sut.convertItemModel.itemsToConvert == ["GBR - Britain Pound","INR - Indian Rupee"])
        XCTAssert(sut.convertItemModel.convertedResult == ["INR  - 83.0","GBR  - 100.0"])
    }
    
    func testStartFailure() {
        let promise = expectation(description: "Start failure")
        sut = CurrencyRateConverterViewPresenter()
        sut.interactor = CurrencyConverterInteractorMockForFailure()
        sut.start({_ in
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
        sut.convert(value: "INR", amount: "4")
        XCTAssert(sut.convertItemModel.itemsToConvert == [])
        XCTAssert(sut.convertItemModel.convertedResult == [])
        XCTAssertNotNil(sut.error)
    }
    
    func testConvertSuccess() {
        let promise = expectation(description: "Convert Success")
        sut = CurrencyRateConverterViewPresenter()
        sut.interactor = CurrencyConverterInteractorMockForSuccess()
        sut.start({_ in
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)
        sut.convert(value: "INR", amount: "4")
        XCTAssert(sut.convertItemModel.itemsToConvert == ["GBR - Britain Pound","INR - Indian Rupee"])
        XCTAssert(sut.convertItemModel.convertedResult == ["GBR  - 4.8","INR  - 4.0"])
    }
    
    func testConvertFilure() {
        let promise = expectation(description: "Convert failure")
        sut = CurrencyRateConverterViewPresenter()
        sut.interactor = CurrencyConverterInteractorMockForFailure()
        sut.start({_ in
            promise.fulfill()
        })
        
        wait(for: [promise], timeout: 10)
        sut.convert(value: "INR", amount: "4")
        XCTAssertNotNil(sut.error)
    }
}
