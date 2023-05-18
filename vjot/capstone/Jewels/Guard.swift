//
//  Guard.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 12/4/23.
//

import Foundation

func recover(jewel: Jewel) -> String {
    switch jewel {
    case .theCatAPIKey:
        guard let propertyList = Bundle.main.path(
            forResource: "TheCatAPIJewel",
            ofType: "plist"
        ) else {
            fatalError()
        }
        let plist = NSDictionary(contentsOfFile: propertyList)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError()
        }
        return value
        
    case .theDogAPIKey:
        guard let file = Bundle.main.path(
            forResource: "TheDogAPIJewel",
            ofType: "plist"
        ) else {
            fatalError()
        }
        let plist = NSDictionary(contentsOfFile: file)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError()
        }
        return value
    }
}
