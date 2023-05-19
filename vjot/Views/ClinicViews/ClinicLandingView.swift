//
//  ClinicLandingView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 26/4/23.
//

import SwiftUI

struct ClinicLandingView: View {
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.pathCli) {
            ClinicLandingListView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ClinicLandingListView: View {
    var body: some View {
        List {
            NavigationLink(value: Role.veterinarians) {
                ClinicLandingListElementView(role: .veterinarians)
                    .foregroundColor(Color.primary)
            }
            NavigationLink(value: Role.incidents) {
                ClinicLandingListElementView(role: .incidents)
                    .foregroundColor(Color.primary)
            }
            NavigationLink(value: Role.patients) {
                ClinicLandingListElementView(role: .patients)
                    .foregroundColor(Color.primary)
            }
            NavigationLink(value: Role.clinic) {
                ClinicLandingListElementView(role: .clinic)
                    .foregroundColor(Color.primary)
            }
        }
        .scrollContentBackground(.hidden)
        .navigationDestination(for: Role.self) { role in
            ClinicRoutingView(role: role)
        }
    }
}


// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{} MARK: ELEMENT
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct ClinicLandingListElementView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var role: Role
    
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
                    GeometryReader { proxy in
                        HStack {
                            Spacer()
                            getText(for: role)
                                .font(.largeTitle)
                            getImage(for: role)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .background()
                                .offset(x: role == .incidents ? 2 : 0)
                                .offset(x: role == .patients ? 3 : 0)
                                .offset(x: role == .clinic ? 5 : 0)
                                .padding()
                        }
                        .frame(width: proxy.size.width * ((1 + sqrt(5)) / 2) * 0.975)   // φ
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
                        getText(for: role)
                            .font(.largeTitle)
                        getImage(for: role)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .clipped()
                            .background()
                            .offset(x: role == .incidents ? -2 : 0)
                            .offset(x: role == .patients ? -3 : 0)
                            .offset(x: role == .clinic ? -5 : 0)
                            .padding()
                        
                    }
                }
                .clipShape(Rectangle())
        }
    }
    
    // ------------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////////
    // ------------------------------------------------------------------------
    
    func getImage(for role: Role) -> Image {
        switch role {
        case .veterinarians:
            return Image("paperStethoscope")
        case .incidents:
            return Image("paperPencil")
        case .patients:
            return Image("paperHeart")
        case .clinic:
            return Image("paperShield")
        }
    }
    
    func getText(for role: Role) -> Text {
        switch role {
        case .veterinarians:
            return Text("vets")
        case .incidents:
            return Text("cases")
        case .patients:
            return Text("pets")
        case .clinic:
            return Text("about")
        }
    }
}


// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct ClinicLandingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClinicLandingView()
//    }
//}
