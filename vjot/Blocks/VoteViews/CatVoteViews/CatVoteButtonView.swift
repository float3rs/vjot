//
//  CatVoteButtonView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct CatVoteButtonView: View {
    var image: CatAPIImage
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var voteEngine: VoteEngine
    
    @State var voted: Bool = false
    @State var goVote: Bool = false
    @State var voteId: Int? = nil
    
    var body: some View {
        
        // ----------------------------------------------------------------
        // CONTENT ////////////////////////////////////////////////////////
        // ----------------------------------------------------------------
        
        ZStack {
            if veterinarianGig.currentId != nil {
                
                // ^%^%^%^%^%^%^%^%
                // IF SIGNED IN %^%
                // ENABLE VOTE ^%^%
                // ^%^%^%^%^%^%^%^%
                
                if voted {
                    
                    // ::::::::::::::::::::::
                    // IF ALREADY VOTED :::::
                    // ::::::::::::::::::::::
                    
                    Button {
                        goVote = true
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(Color.yellow)
                            .font(.title3)
                    }
                    .buttonStyle(.bordered)
                    
                } else {
                    
                    // ::::::::::::::::::::::
                    // IF NOT VOTED :::::::::
                    // ::::::::::::::::::::::
                    
                    Button {
                        goVote = true
                    } label: {
                        Image(systemName: "paperplane")
                            .foregroundColor(Color.primary)
                            .font(.title3)
                    }
                    .buttonStyle(.bordered)
                }
                
            } else {
                
                // ^%^%^%^%^%^%^%^%
                // IF SIGNED OUT ^%
                // DISABLE VOTE %^%
                // ^%^%^%^%^%^%^%^%
                
                Button {
                    
                } label: {
                    Image(systemName: "location.slash")
                        .foregroundColor(Color.secondary)
                        .font(.title3)
                }
                .buttonStyle(.bordered)
                .disabled(true)
            }
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
        // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|> MARK: VOTE SHEET
        // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
        
        .sheet(isPresented: $goVote, content: {
            CatVoteSheetView(image: image, voted: $voted, goVote: $goVote)
        })
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)( MARK: ON APPEAR
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // \/\/\/\/\/\/\/\/\/\
        // ALREADY VOTED? /\/\
        // \/\/\/\/\/\/\/\/\/\
        
        .onAppear {
            if let currentId = veterinarianGig.currentId {
                if let currentVet = veterinarianGig.track(currentId:currentId) {
                    if let voteId = currentVet.catVotes[image.id] {
                        voted = true
                        self.voteId = voteId
                    } else {
                        voted = false
                        self.voteId = nil
                    }
                }
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)( MARK: ON CHANGE
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // \/\/\/\/\/\/\/\/\/\
        // ALREADY FAVED? /\/\
        // \/\/\/\/\/\/\/\/\/\
        
        .onChange(of: image, perform: { newValue in
            if let currentId = veterinarianGig.currentId {
                if let currentVet = veterinarianGig.track(currentId:currentId) {
                    if let voteId = currentVet.catVotes[newValue.id] {
                        voted = true
                        self.voteId = voteId
                    } else {
                        voted = false
                        self.voteId = nil
                    }
                }
            }
        })
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatVoteButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatVoteButtonView()
//    }
//}
