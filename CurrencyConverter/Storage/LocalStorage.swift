//
//  LocalStorage.swift
//  CurrencyConverter
//
//  Created by Babul Raj on 29/12/22.
//

import Foundation

enum StorageError: Error, CustomStringConvertible {
    case storageError
    case unknown
    
    var description: String {
        //info for debugging
        switch self {
        case .unknown: return "unknown error"
        case .storageError: return "Error in storing value"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .storageError, .unknown:
            return "Sorry, something went wrong."
        }
    }
}


protocol LocalStorageProtocol {
    func getCurrencyRate(for currency:String, amount: Double) -> Result<CurrencyRateNetworkModel,Error>
    func saveData(response: CurrencyRateNetworkModel)
}

class LocalStorage: LocalStorageProtocol {
    public static let shared = LocalStorage()
   
    func getCurrencyRate(for currency:String, amount: Double) -> Result<CurrencyRateNetworkModel,Error> {
        if let item = CoredataManager.shared.fetchObjects(attributes: ["base" : currency], inputType: CurrencyCoreDataModel.self)?.first {
            var model = CurrencyRateNetworkModel(base: item.base ?? "", timestamp: item.timeStamp)
            if let rates = item.rates as? Set<CurrencyRateCoreDataModel> {
                model.rates =  Dictionary(uniqueKeysWithValues: rates.map{ ($0.currency ?? "", $0.value ) })
            }
            
            return .success(model)
        }
        
        return .failure(StorageError.storageError)
    }
    
    func saveData(response: CurrencyRateNetworkModel) {
        if let currency = CoredataManager.shared.fetchObjects(attributes: ["base" : response.base], inputType: CurrencyCoreDataModel.self)?.first {
            currency.base = response.base
            currency.timeStamp = response.timestamp
            currency.rates = nil
            
            for item in response.rates {
                if let currencyRateCoredataModel = CoredataManager.shared.fetchObjects(attributes: ["currency" : item.key], inputType: CurrencyRateCoreDataModel.self)?.first  {
                    currencyRateCoredataModel.currency = item.key
                    currencyRateCoredataModel.value = item.value
                    currency.addToRates(currencyRateCoredataModel)
                } else {
                    let currencyRateCoredataModel = CurrencyRateCoreDataModel(context: CoredataManager.shared.context)
                    currencyRateCoredataModel.currency = item.key
                    currencyRateCoredataModel.value = item.value
                    currency.addToRates(currencyRateCoredataModel)
                }
            }
        } else {
            let currency = CurrencyCoreDataModel(context: CoredataManager.shared.context)
            currency.base = response.base
            currency.timeStamp = response.timestamp
            
            for item in response.rates {
                let currencyRateCoredataModel = CurrencyRateCoreDataModel(context: CoredataManager.shared.context)
                currencyRateCoredataModel.currency = item.key
                currencyRateCoredataModel.value = item.value
                currency.addToRates(currencyRateCoredataModel)
            }
        }
        
        CoredataManager.shared.saveContext()
    }
}


