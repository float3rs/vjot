//
//  DogVoteDetailsView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct DogVoteDetailsView: View {
    var vote: DogAPIVote
    
    var body: some View {
        VStack(alignment: .vjotFavH, spacing: -2) {
            HStack {
                Text("value:")
                    .foregroundColor(Color.secondary)
                Text(String(vote.value))
                    .alignmentGuide(.vjotFavH) { $0[.leading] }
            }
            HStack {
                Text("vote:")
                    .foregroundColor(Color.secondary)
                Text(String(vote.id))
                    .alignmentGuide(.vjotFavH) { $0[.leading] }
            }
            if let createdAt = vote.createdAt {
                HStack {
                    Text("created:")
                        .foregroundColor(Color.secondary)
                    Text(String(createdAt.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "")))
                        .alignmentGuide(.vjotFavH) { $0[.leading] }
                }
            }
            if let subId = vote.subId {
                HStack {
                    Text("user:")
                        .foregroundColor(Color.secondary)
                    Text(subId.uuidString)
                        .alignmentGuide(.vjotFavH) { $0[.leading] }
                }
            }
            if let countryCode = vote.countryCode {
                HStack {
                    Text("country:")
                        .foregroundColor(Color.secondary)
                    Text(String(countryCode))
                        .alignmentGuide(.vjotFavH) { $0[.leading] }
                }
            }
            HStack {
                Text("image:")
                    .foregroundColor(Color.secondary)
                Text(String(vote.imageId))
                    .alignmentGuide(.vjotFavH) { $0[.leading] }
            }
        }
        .font(.footnote)
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct DogVoteDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogVoteDetailsView()
//    }
//}
