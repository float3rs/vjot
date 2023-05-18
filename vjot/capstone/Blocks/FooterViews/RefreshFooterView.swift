//
//  RefreshFooterView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import SwiftUI

struct RefreshFooterView: View {
    var body: some View {
        HStack {
            Text("pull to refresh")
            Image(systemName: "hand.draw.fill")
                .rotationEffect(.degrees(180))
            
        }
        .padding(.vertical, 5)
        .padding(.bottom, 5)
        .foregroundColor(.accentColor)
        .font(.headline)
        .fontWeight(.regular)
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct RefreshFooterView_Previews: PreviewProvider {
//    static var previews: some View {
//        RefreshFooterView()
//    }
//}
