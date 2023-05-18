//
//  DogInfoHomeView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import SwiftUI

struct DogInfoHomeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        DogInfoProcessesListView()
            .navigationBarTitleDisplayMode(.inline)
    }
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: LIST
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct DogInfoProcessesListView: View {
    var body: some View {
        List {
            NavigationLink {
                DogInfoSourcesView()
            } label: {
                DogInfoProcessesListElementView(process: .sources)
            }
            NavigationLink {
                DogInfoVersionView()
            } label: {
                DogInfoProcessesListElementView(process: .version)
            }
        }
        .scrollContentBackground(.hidden)
    }
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{} MARK: ELEMENT
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct DogInfoProcessesListElementView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var process: InfoProcess
    
    var body: some View {
        switch verticalSizeClass {
            
            // ::::::::::::::
            // LANDSCAPE ::::
            // ::::::::::::::
            
        case .compact:
                Rectangle()
                    .foregroundColor(Color(uiColor: UIColor.systemBackground))
                    .aspectRatio(
                        ((1 + sqrt(5)) / 2) * 3,
                        contentMode: .fit
                    )
                    .background(Color.primary)
                    .overlay {

                            HStack {
                                Spacer()
                                getText(for: process)
                                    .font(.largeTitle)
                                getImage(for: process)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .background()
                        }
                    }
                    .clipShape(Rectangle())
            
            // ::::::::::::::
            // PORTRAIT :::::
            // ::::::::::::::
            
        default:
            Rectangle()
                .foregroundColor(Color(uiColor: UIColor.systemBackground))
                .aspectRatio(
                    ((1 + sqrt(5)) / 2) * 2,
                    contentMode: .fit
                )
                .background(Color.primary)
                .overlay {

                        HStack {
                            Spacer()
                            getText(for: process)
                                .font(.largeTitle)
                            getImage(for: process)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .background()
                    }
                }
                .clipShape(Rectangle())
        }
    }
    
    // ------------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////////
    // ------------------------------------------------------------------------
    
    func getImage(for process: InfoProcess) -> Image {
        switch process {
        case .sources:
            return Image("imageSources")
        case .version:
            return Image("imageVersion")
        }
    }
    
    func getText(for process: InfoProcess) -> Text {
        switch process {
        case .sources:
            return Text("sources")
        case .version:
            return Text("version")
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct DogInfoHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogInfoHomeView()
//    }
//}
