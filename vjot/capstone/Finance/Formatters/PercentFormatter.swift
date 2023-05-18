//
//  PercentFormatter.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2/5/23.
//

import Foundation

// The textual representation of PERCENT: "42.00%"
// NumberFormatter instances format the textual representation of cells that contain NSNumber objects.

extension NumberFormatter {
    static var percentFormatter: NumberFormatter {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .percent
            return numberFormatter
        }
    }
}
