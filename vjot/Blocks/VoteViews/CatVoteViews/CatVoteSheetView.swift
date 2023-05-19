//
//  CatVoteSheetView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 22/4/23.
//

import SwiftUI

struct CatVoteSheetView: View {
    var image: CatAPIImage
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var voted: Bool
    @Binding var goVote: Bool
    
    var body: some View {
        ZStack {
            CatVoteView(
                image: image,
                voted: $voted,
                goVote: $goVote
            )
            
            // <|><|><|><|><|><|><|><|>
            // DISMISS BUTTON <|><|><|>
            // <|><|><|><|><|><|><|><|>
            
            VStack {
                HStack {
                    
                    // {-}{-}{-}{-}{-}{
                    // HSPACER }{-}{-}{
                    // {-}{-}{-}{-}{-}{
                    
                    Spacer()
                    
                    // {-}{-}{-}{-}{-}{
                    // BUTTON -}{-}{-}{
                    // {-}{-}{-}{-}{-}{
                    
                    Button {
                        goVote = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .padding()
                    }
                }
                
                // {-}{-}{-}{
                // VSPACER }{
                // {-}{-}{-}{
                
                Spacer()
            }
        }
        
        // (%)(%)(%)(%)(%)(%)(%)(%)(%)(
        // BACKGROUND )(%)(%)(%)(%)(%)(
        // (%)(%)(%)(%)(%)(%)(%)(%)(%)(
        
        .background {
            AsyncImage(url: image.url) { phase in
                switch phase {
                    
                    // ------------
                    // EMPTY //////
                    // ------------
                    
                case .empty:
                    EmptyView()
                    
                    // ------------
                    // SUCCESS ////
                    // ------------
                    
                case .success(let returnedImage):
                    returnedImage
                        .resizable()
                        .overlay(.thinMaterial)
                        .aspectRatio(contentMode: .fill)
                        .brightness(colorScheme == .light ? 0.1 : -0.1)
                    
                    // ------------
                    // FAILURE ////
                    // ------------
                    
                case .failure(_):
                    EmptyView()
                    
                    // ------------
                    // DEFAULT ////
                    // ------------
                    
                default:
                    fatalError()
                }
            }
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatVoteSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatVoteSheetView()
//    }
//}
