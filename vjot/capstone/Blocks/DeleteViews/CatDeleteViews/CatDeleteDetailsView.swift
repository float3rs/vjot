//
//  CatDeleteDetailsView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct CatDeleteDetailsView: View {
    var image: CatAPIImage
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @Binding var deleted: Bool
    
    var body: some View {
        VStack {
            
            // ----------------------------------------------------------------
            // CONTENT ////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            if !deleted {
                
                // {}{}{}{}{}{}{}{}{}{}{}{}
                // THE CALLOUT {}{}{}{}{}{}
                // {}{}{}{}{}{}{}{}{}{}{}{}
                
                VStack(spacing: -12) {
                    Text("uploaded by:")
                        .foregroundColor(Color.secondary)
                    if let subId = image.subId {
                        if subId == veterinarianGig.currentId {
                            
                            // ::::::::::::::::::::::::::::
                            // IF CURRENT USER ::::::::::::
                            // IS THE UPLOADER ::::::::::::
                            // ::::::::::::::::::::::::::::
                            
                            Text("you")
                                .foregroundColor(Color.primary)
                            
                        } else {
                            
                            // ::::::::::::::::::::::::::::
                            // IF CURRENT USER ::::::::::::
                            // ISN'T THE UPLOADER :::::::::
                            // ::::::::::::::::::::::::::::
                            
                            if let vet = veterinarianGig.track(currentId: subId) {
                                
                                // <^><^><^><^><^><^><^><^><^><^><^><^><^><^><^
                                // IF THE UPLOADER IS ONE OF THE USERS <^><^><^
                                // <^><^><^><^><^><^><^><^><^><^><^><^><^><^><^
                                
                                Text(vet.name)
                                    .foregroundColor(Color.primary)
                                
                            } else {
                                
                                // <^><^><^><^><^><^><^><^><^><^><^><^><^><^><^
                                // IF THE UPLOADER ISN"T ONE OF THE USERS <^><^
                                // <^><^><^><^><^><^><^><^><^><^><^><^><^><^><^
                                
                                Text("someone uknown")
                                    .foregroundColor(Color.primary)
                            }
                        }
                    }
                    
                    // [/][/][/][/][/][
                    // THE INTERVAL /][
                    // [/][/][/][/][/][
                    
                    if let createdAt = image.createdAt {
                        VStack(spacing: -8) {
                            Text("approximately")
                            Text("\(interval(date: createdAt)) ago")
                        }
                        .foregroundColor(Color.secondary)
                        .font(.title3)
                        .padding(5)
                    }
                }
                .font(.title)
            }
        }
    }
    
    // --------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////
    // --------------------------------------------------------------------
    
    func interval(date: Date) -> String {
        
        let formatter = DateComponentsFormatter()

        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .spellOut
        formatter.zeroFormattingBehavior = .dropAll
        
        let elapsed = Date().timeIntervalSince(date)
        guard let interval = formatter.string(from: elapsed) else { return "" }
        return interval
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatDeleteDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatDeleteDetailsView()
//    }
//}
