//
//  PercentFormattable.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2/5/23.
//

import Foundation

// Types that are formattable as PERCENT should:
//
//  -   Be represented as Decimal:  48.24
//  -   Be represented as String:   "48.24%"
//  -   Be initialized as Decimal:  Discount(48.24)
//  -   Be initialized as String:   Discount("48.24%")
//
//  -   Support functionality:
//      -   To be converted from String to Decimal: getDecimal(from: "48.24%") ->   48.24
//      -   To be converted from Decimal to String: getString(from:    48.24 ) -> "48.24%"

protocol PercentFormattable {
    var decimal: Decimal? {get set}
    var string: String? {get set}
    
    func getDecimal(from string: String) -> Decimal?
    func getString(from decimal: Decimal) -> String?
    
    init(_ percent: Decimal)
    init(_ percent: String)
}

extension PercentFormattable {
    
    // default implementation of function to convert percentage
    // from String ("48.2%") to Decimal? (0.482)
    
    func getDecimal(from string: String) -> Decimal? {
        return NumberFormatter.percentFormatter.number(
            from: string
        )?.decimalValue
    }
    
    // default implementation of function to convert currency
    // from Decimal (0.482) to String? ("48.2%")

    func getString(from decimal: Decimal) -> String? {
        return NumberFormatter.percentFormatter.string(
            from: NSDecimalNumber(decimal: decimal)
        )
    }
}
