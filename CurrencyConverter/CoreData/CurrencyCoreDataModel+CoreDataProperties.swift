//
//  CurrencyCoreDataModel+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Babul Raj on 30/12/22.
//
//

import Foundation
import CoreData


extension CurrencyCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyCoreDataModel> {
        return NSFetchRequest<CurrencyCoreDataModel>(entityName: "CurrencyCoreDataModel")
    }

    @NSManaged public var base: String?
    @NSManaged public var timeStamp: Double
    @NSManaged public var rates: NSSet?

}

// MARK: Generated accessors for rates
extension CurrencyCoreDataModel {

    @objc(addRatesObject:)
    @NSManaged public func addToRates(_ value: CurrencyRateCoreDataModel)

    @objc(removeRatesObject:)
    @NSManaged public func removeFromRates(_ value: CurrencyRateCoreDataModel)

    @objc(addRates:)
    @NSManaged public func addToRates(_ values: NSSet)

    @objc(removeRates:)
    @NSManaged public func removeFromRates(_ values: NSSet)

}

extension CurrencyCoreDataModel : Identifiable {

}
