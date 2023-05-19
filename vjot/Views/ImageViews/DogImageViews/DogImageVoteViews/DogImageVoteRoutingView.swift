//
//  DogImageVoteRoutingView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct DogImageVoteRoutingView: View {
    var count: Int
    
    var body: some View {
        
        switch count {
        case 1:
            DogImageVoteView()
        case 2:
            DogImageVoteXView()
        case 3:
            DogImageVoteFindView()
        default:
            self
        }
    }
}

//struct DogUsersVoteRoutingView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogImageVoteRoutingView()
//    }
//}
