//
//  ContentView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-02-18.
//

import SwiftUI

struct ContentView: View {
        
    // edit CapstoneView to select between
    // production and developement mode
    
    var body: some View {
        CapstoneView()          //   COMMENT OUT FOR HOMEWORK
        // HomeworkView()       // UNCOMMENT     FOR HOMEWORK
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
