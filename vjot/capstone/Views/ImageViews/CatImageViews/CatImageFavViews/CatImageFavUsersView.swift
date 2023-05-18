//
//  CatImageFavUsersView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 20/4/23.
//

import SwiftUI

struct CatImageFavUsersView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var router: Router
    
    var body: some View {
        CatImageFavUserList()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !router.pathIma.isEmpty {

                            // <+><+><+><+><+><+><+><+><+
                            // PATH FOR IMAGES TAB ><+><+
                            // <+><+><+><+><+><+><+><+><+

                            router.pathIma.removeLast()
                        }
                    } label: {
                        Label("BACK TO CATS", systemImage: "photo.on.rectangle")
                    }
                }
            }
    }
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: LIST
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct CatImageFavUserList: View {
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    
    var body: some View {
        List {
            NavigationLink {
                CatImageFavRoutingView(count: 1)
            } label: {
                CatImageFavRoutingListElement(count: 1)
            }
            NavigationLink {
                CatImageFavRoutingView(count: 2)
            } label: {
                CatImageFavRoutingListElement(count: 2)
            }
            NavigationLink {
                CatImageFavRoutingView(count: 3)
            } label: {
                CatImageFavRoutingListElement(count: 3)
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

struct CatImageFavRoutingListElement: View {
    var count: Int

    @Environment(\.verticalSizeClass) var verticalSizeClass

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
                    if let image = getImage(for: count) {
                        if let text = getText(for: count) {
                            HStack(spacing: 5) {
                                Spacer()
                                text
                                    .font(.largeTitle)
                                image
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .background()
                            }
                        }
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
                    if let image = getImage(for: count) {
                        if let text = getText(for: count) {
                            HStack(spacing: 5) {
                                Spacer()
                                text
                                    .font(.largeTitle)
                                image
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .background()
                            }
                        }
                    }
                }
                .clipShape(Rectangle())

        }
    }

    // ------------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////////
    // ------------------------------------------------------------------------

    func getImage(for count: Int) -> Image? {
        switch count {
        case 1:
            return Image("image1")
        case 2:
            return Image("image2")
        case 3:
            return Image("heart")
        default:
            return nil
        }
    }
    
    func getText(for count: Int) -> Text? {
        switch count {
        case 1:
            return Text("yours")
        case 2:
            return Text("everyone's")
        case 3:
            return Text("precise")
        default:
            return nil
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatImageFavUsersView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatImageFavUsersView()
//    }
//}
