//
//  CatUploadDetailsView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct CatUploadDetailsView: View {
    var image: CatAPIImage
    
    var body: some View {
        VStack(alignment: .vjotUploadH, spacing: -2) {
            HStack {
                Text("via:")
                    .foregroundColor(Color.secondary)
                if let subId = image.subId {
                    Text(subId.uuidString)
                        .alignmentGuide(.vjotUploadH) { $0[.leading] }
                }
            }
            HStack {
                Text("to:")
                    .foregroundColor(Color.secondary)
                if let url = image.url {
                    Text(url.absoluteString)
                        .alignmentGuide(.vjotUploadH) { $0[.leading] }
                }
            }
            if let createdAt = image.createdAt {
                HStack {
                    Text("on:")
                        .foregroundColor(Color.secondary)
                    Text(createdAt.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                        .alignmentGuide(.vjotUploadH) { $0[.leading] }
                }
            }
            if let originalFilename = image.originalFilename {
                HStack {
                    Text("of:")
                        .foregroundColor(Color.secondary)
                    Text(originalFilename)
                        .alignmentGuide(.vjotUploadH) { $0[.leading] }
                }
            }
        }
        .font(.caption)
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatUploadDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatUploadView()
//    }
//}
