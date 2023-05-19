//
//  DogImageHomeView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 19/4/23.
//

import SwiftUI

struct DogImageHomeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        DogImageProcessesListView()
            .navigationBarTitleDisplayMode(.inline)
    }
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: LIST
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct DogImageProcessesListView: View {
    var body: some View {
        List {
            NavigationLink {
                DogImageSearchView()
            } label: {
                DogImageProcessesListElementView(process: .search)
            }
            NavigationLink {
                DogImageFindView()
            } label: {
                DogImageProcessesListElementView(process: .find)
            }
            NavigationLink {
                DogImageUploadView()
            } label: {
                DogImageProcessesListElementView(process: .upload)
            }
            NavigationLink {
                DogImageFavUsersView()
            } label: {
                DogImageProcessesListElementView(process: .fav)
            }
            NavigationLink {
                DogImageVoteUsersView()
            } label: {
                DogImageProcessesListElementView(process: .vote)
            }
            NavigationLink {
                DogImageDeleteView()
            } label: {
                DogImageProcessesListElementView(process: .delete)
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

struct DogImageProcessesListElementView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var process: ImageProcess
    
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
    
    func getImage(for process: ImageProcess) -> Image {
        switch process {
        case .search:
            return Image("imageSearch")
        case .find:
            return Image("imageFind")
        case .upload:
            return Image("imageUpload")
        case .fav:
            return Image("imageFav")
        case .vote:
            return Image("imageVote")
        case .delete:
            return Image("imageMissing")
        }
    }
    
    func getText(for process: ImageProcess) -> Text {
        switch process {
        case .search:
            return Text("search")
        case .find:
            return Text("find")
        case .upload:
            return Text("upload")
        case .fav:
            return Text("fav")
        case .vote:
            return Text("vote")
        case .delete:
            return Text("delete")
        }
    }
}


// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct DogImageHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogImageHomeView()
//    }
//}
