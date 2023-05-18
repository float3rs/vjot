//
//  CatImageVoteRoutingView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct CatImageVoteRoutingView: View {
    var count: Int
    
    var body: some View {
        
        switch count {
        case 1:
            CatImageVoteView()
        case 2:
            CatImageVoteXView()
        case 3:
            CatImageVoteFindView()
        default:
            self
        }
    }
}

//struct CatImageVoteRoutingView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatImageVoteRoutingView()
//    }
//}
