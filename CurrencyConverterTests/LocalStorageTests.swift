//
//  LocalStorageTests.swift
//  CurrencyConverterTests
//
//  Created by Babul Raj on 03/01/23.
//

import XCTest
import CoreData
@testable import CurrencyConverter

final class LocalStorageTests: XCTestCase {
    var sut: LocalStorage!
    override func setUpWithError() throws {
         sut = LocalStorage()
        sut.saveData(response: CurrencyRateNetworkModel(base: "USD", timestamp: 2, rates: ["INR":83, "GBR":100]))
    }
    
    override func tearDownWithError() throws {}
    
    func testCoreData() {
        let some =  sut.getCurrencyRate(for: "USD", amount: 3)
        switch some {
        case .success(let model) :
            XCTAssertEqual(model.base, "USD")
            XCTAssertEqual(model.rates.count, 2)
            XCTAssertEqual(model.timestamp, 2 )
        case .failure(_):
            print("error")
        }
    }
}

