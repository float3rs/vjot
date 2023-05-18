//
//  CatAnalysisButtonView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct CatAnalysisButtonView: View {
    var image: CatAPIImage
    
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
            CatAnalysisSheetView(image: image, goAnalyze: $goAnalyse)
        })
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatAnalysisButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CatAnalysisButtonView()
//    }
//}
