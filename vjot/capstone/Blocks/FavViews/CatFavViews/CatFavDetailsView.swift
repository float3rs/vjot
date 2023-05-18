//
//  CatFavDetailsView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct CatFavDetailsView: View {
    var favourite: CatAPIFavourite
    
    var body: some View {
        VStack(alignment: .vjotFavH, spacing: -2) {
            HStack {
                Text("fav:")
                    .foregroundColor(Color.secondary)
                Text(String(favourite.id))
                    .alignmentGuide(.vjotFavH) { $0[.leading] }
            }
            HStack {
                Text("created:")
                    .foregroundColor(Color.secondary)
                Text(String(favourite.createdAt.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "")))
                    .alignmentGuide(.vjotFavH) { $0[.leading] }
            }
            HStack {
                Text("user:")
                    .foregroundColor(Color.secondary)
                Text(favourite.subId.uuidString)
                    .alignmentGuide(.vjotFavH) { $0[.leading] }
            }
            if let userId = favourite.userId {
                HStack {
                    Text("sandbox:")
                        .foregroundColor(Color.secondary)
                    Text(userId)
                        .alignmentGuide(.vjotFavH) { $0[.leading] }
                }
            }
            HStack {
                Text("image:")
                    .foregroundColor(Color.secondary)
                Text(String(favourite.imageId))
                    .alignmentGuide(.vjotFavH) { $0[.leading] }
            }
        }
        .font(.footnote)
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatFavDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatFavDetailsView()
//    }
//}
