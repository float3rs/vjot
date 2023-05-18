//
//  IncidentCaseView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 25/4/23.
//

import SwiftUI

struct IncidentCaseView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var incidentGig: IncidentGig
    
    var incident: Incident? = nil
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ScrollView {
            
        }
        
        // ----------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////
        // ----------------------------------------------------------------
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@ MARK: NAVIGATION
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        
//        .navigationTitle("case")
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden(false)
        .navigationSplitViewStyle(.automatic)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink {
                    JotterView(function: .update, incident: incident)
                } label: {
                    Label("Edit", systemImage: "square.and.pencil")
                        .font(.headline)
                }
            }
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct IncidentCaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        IncidentCaseView()
//    }
//}
