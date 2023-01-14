//
//  ModelsAndProtocols.swift
//  CurrencyConverter
//
//  Created by Babul Raj on 29/12/22.
//

import Foundation
import Combine

struct CurrencyModel {
    var base: String
    var timestamp: Double
    var rates: [String:Double] = [:]
}

protocol CurrencyConverterInteractorProtocol {
    func getCurrencyRate(for currency: String, completion:@escaping (Result<CurrencyModel,Error>) -> ())
    func getCountriesList(completion:@escaping (Result<[String:String],Error>) -> ())
}
