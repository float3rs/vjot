//
//  DiscountModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2/5/23.
//

import Foundation

struct Discount: PercentFormattable {
    var id = UUID()
    
    var decimal: Decimal?
    var string: String?
    
    init(_ percent: Decimal) {
        self.decimal = percent
        self.string = getString(from: percent)
    }
    init(_ percent: String) {
        self.string = percent
        self.decimal = getDecimal(from: percent)
    }
}

// ----------------------------------------------------------------------------

extension Discount: Codable & Identifiable & Hashable {}
