//
//  DogAnalysisButtonView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct DogAnalysisButtonView: View {
    var image: DogAPIImage
    
    @State var analysed: Bool = false
    @State var goAnalyse: Bool = false
    
    var body: some View {
        ZStack {
            
            // ----------------------------------------------------------------
            // CONTENT ////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            if analysed {
                
                // ::::::::::::::::::::::
                // IF ALREADY ANALYSED ::
                // ::::::::::::::::::::::
                
                Button {
                    goAnalyse = true
                    analysed = true
                } label: {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(Color.green)
                        .font(.title3)
                }
                .buttonStyle(.bordered)
                
            } else {
                
                // ::::::::::::::::::::::
                // IF NOT ANALYSED ::::::
                // ::::::::::::::::::::::
                
                Button {
                    goAnalyse = true
                    analysed = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color.primary)
                        .font(.title3)
                }
                .buttonStyle(.bordered)
            }
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
        // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|> MARK: VOTE SHEET
        // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
        
        .sheet(isPresented: $goAnalyse, content: {
            DogAnalysisSheetView(image: image, goAnalyze: $goAnalyse)
        })
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct DogAnalysisButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DogAnalysisButtonView()
//    }
//}
