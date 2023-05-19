//
//  DescriptionOfAnimalModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation
import SwiftUI

struct DescriptionOfAnimal {
    var pictureId: UUID?
    var name: String?            // as stated by owner
    var species: Species?
    var breed: String?           // as stated by owner
    var sex: Sex?
    var dateOfBirth: Date?       // as stated by owner
    var colour: Color?
    var notableOrDiscernableFeaturesOrCharacteristics: String?
}

// ----------------------------------------------------------------------------

extension DescriptionOfAnimal: Codable & Hashable {}

// ----------------------------------------------------------------------------
// http://brunowernimont.me/howtos/make-swiftui-color-codable
// https://www.hackingwithswift.com/example-code/uicolor/how-to-read-the-red-green-blue-and-alpha-color-components-from-a-uicolor
// https://nilcoalescing.com/blog/EncodeAndDecodeSwiftUIColor/
// https://github.com/NilCoalescing/SwiftUI-Code-Examples/blob/main/Encode-and-Decode-Color/Save-ColorPicker-Color-via-UIColor-or-NSColor.swift


extension Color: Codable {

    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }

    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)

        self.init(red: r, green: g, blue: b)
    }

    public func encode(to encoder: Encoder) throws {
        guard let components = self.components else { return }

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(components.red, forKey: .red)
        try container.encode(components.green, forKey: .green)
        try container.encode(components.blue, forKey: .blue)
    }
}

