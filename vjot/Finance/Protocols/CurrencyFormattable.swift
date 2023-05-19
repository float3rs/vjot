//
//  CurrencyFormattable.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2/5/23.
//

import Foundation

// Types that are formattable as CURRENCY should:
//
//  -   Be represented as Decimal:  48.24
//  -   Be represented as String:   "€48.24"
//  -   Be initialized as Decimal:  Price(48.24)
//  -   Be initialized as String:   Price("€48.24")
//
//  -   Support functionality:
//      -   To be converted from String to Decimal: getDecimal(from: "€48.24") ->   48.24
//      -   To be converted from Decimal to String: getString(from:    48.24 ) -> "€48.24"

protocol CurrencyFormattable {
    var decimal: Decimal? {get set}
    var string: String? {get set}
    
    func getDecimal(from string: String) -> Decimal?
    func getString(from decimal: Decimal) -> String?
    
    init(_ currency: Decimal)
    init(_ currency: String)
}

extension CurrencyFormattable {
    
    // default implementation of function to convert currency
    // from String ("€48.24") to Decimal? (48.24)
    
    func getDecimal(from string: String) -> Decimal? {
        return NumberFormatter.currencyFormatter.number(
            from: string
        )?.decimalValue
    }
    
//    func getDecimal(from string: String) -> Decimal? {
//        return 999.99
//    }
    
    // default implementation of function to convert currency
    // from Decimal (48.24) to String? ("€48.24")

    func getString(from decimal: Decimal) -> String? {
        return NumberFormatter.currencyFormatter.string(
            from: NSDecimalNumber(decimal: decimal)
        )
    }
}

// BUG REPORT
//
// from     Cost(42.00)         you get     Cost(decimal: Optional(42), string: Optional("€ 42.00"))
// from     Cost("€42.00")      you get     Cost(decimal: Optional(42), string: Optional("€42.00"))
// from     Cost("€ 42.00")     you get     Cost(decimal: nil,          string: Optional("€ 42.00"))
//
// Notice the space character between € and the number!
//
// CODE TO REPRODUCE
//
// Button {
//     print(Cost(42.0))
//     print(Cost("€42.00"))
//     print(Cost("€ 42.00"))
// } label: {
//     Text("BUG")
// }
//
// TODO: Extend String to get "€42.00" from "€ 42.00"
// Bug cannot be reproduced in playgrounds!
//
//
//
// IMPORTANT:
//
// (Cost(42.0).string!).replacingOccurrences(of: " ", with: "")
//
// " " is no regular space, I copied and pasted from Console
//
// print(" ".unicodeScalars.first!.value)   produces 32
// print(" ".unicodeScalars.first!.value)   produces 160
//
//  &#32; is the classic space
// &#160; represents the non-breaking space
