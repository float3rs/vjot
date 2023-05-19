//
//  CostModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2/5/23.
//

import Foundation

struct Cost: CurrencyFormattable {
    var id = UUID()
    
    var decimal: Decimal?
    var string: String?
    
    init(_ currency: Decimal) {
        self.decimal = currency
        self.string = getString(from: currency)
    }
    init(_ currency: String) {
        self.string = currency
        self.decimal = getDecimal(from: currency)
    }
}

// ----------------------------------------------------------------------------

extension Cost: Codable & Identifiable & Hashable {}
