//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Babul Raj on 29/12/22.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    var body: some Scene {
        WindowGroup {
            ConverterView(presenter: CurrencyRateConverterViewPresenter())
        }
    }
}
