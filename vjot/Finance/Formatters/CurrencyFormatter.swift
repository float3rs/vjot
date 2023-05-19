//
//  CurrencyFormatter.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2/5/23.
//

import Foundation

// The textual representation of CURRENCY: "€42.00"
// NumberFormatter instances format the textual representation of cells that contain NSNumber objects.

extension NumberFormatter {
    static var currencyFormatter: NumberFormatter {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.currencyCode = "EUR"
            numberFormatter.currencySymbol = "€"
            numberFormatter.locale = .current
//            numberFormatter.locale = Locale(identifier: "en_US_POSIX") // Lost hours upon hours to debug...
            return numberFormatter
        }
    }
}
