//
//  VeterinarianIncidentsView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 10/4/23.
//

import SwiftUI

struct VeterinarianIncidentsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var router: Router
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var incidentGig: IncidentGig
    @State var veterinarian: Veterinarian
    @State var incidentIds: [UUID]
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ScrollView {
            
            // ----------------------------------------------------------------
            // CONTENT ////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            VStack {
                
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: INCIDENT
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)
                // <|><|><|><|><|><|><|
                // LOOP INCIDENTS <|><|
                // <|><|><|><|><|><|><|
                
                ForEach(incidentIds, id: \.self) { incidentId in
                    if let incident = veterinarianGig.find(incidentId: incidentId) {
                        VStack {
                            
                            // <|><|><|><|><|><|>
                            // LOOP IDEAS ><|><|>
                            // <|><|><|><|><|><|>
                            
                            Text("IDEAS")
                                .padding()
                            
                            ForEach(incident.ideas) { idea in
                                VStack {
                                    Text(idea.date.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                    if let text = incidentGig.find(ideaId: idea.id).0 {
                                        Text(text)
                                    }
                                }
                            }
                            
                            // <|><|><|><|><|><|>
                            // LOOP SNAPS ><|><|>
                            // <|><|><|><|><|><|>
                            
                            Text("SNAPS")
                                .padding()
                            
                            ForEach(incident.snaps) { snap in
                                VStack {
                                    Text(snap.date.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                    AsyncImage(url: incidentGig.find(snapId: snap.id)) { phase in
                                        switch phase {
                                            
                                            // ----------------
                                            // EMPTY //////////
                                            // ----------------
                                            
                                        case .empty:
                                            ProgressView()
                                            
                                            // ----------------
                                            // SUCCESS ////////
                                            // ----------------
                                            
                                        case .success(let returnedImage):
                                            returnedImage
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(15)
                                                .padding(.horizontal)
                                                .padding(.bottom)
                                            
                                            // ----------------
                                            // FAILURE ////////
                                            // ----------------
                                            
                                        case .failure:
                                            Color.clear
                                            
                                            // ----------------
                                            // DEFAULT ////////
                                            // ----------------
                                            
                                        default:
                                            fatalError()
                                        }
                                    }
                                }
                            }
                        
                            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+ MARK: INCIDENT DETAILS
                            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                            // ?|?|?|?|?|?|?|?|?|?|
                            // ID |?|?|?|?|?|?|?|?|
                            // ?|?|?|?|?|?|?|?|?|?|
                            
                            HStack {
                                Text("Id:")
                                    .foregroundColor(Color.secondary)
                                Text(incident.id.uuidString)
                                    .foregroundColor(Color.primary)
                            }
                            .font(.caption2)
                            
                            // ?|?|?|?|?|?|?|?|?|?|
                            // DESCRIPTION ?|?|?|?|
                            // ?|?|?|?|?|?|?|?|?|?|
                            
                            HStack {
                                Text("Description:")
                                    .foregroundColor(Color.secondary)
                                Text(incident.description)
                                    .foregroundColor(Color.primary)
                            }
                            .font(.footnote)
                            
                            // ?|?|?|?|?|?|?|?|?|?|
                            // DATE |?|?|?|?|?|?|?|
                            // ?|?|?|?|?|?|?|?|?|?|
                            
                            HStack {
                                Text("Date:")
                                    .foregroundColor(Color.secondary)
                                Text(incident.date.formatted(date: .abbreviated, time: .shortened))
                                    .foregroundColor(Color.primary)
                            }
                            .font(.footnote)
                            
                            // ?|?|?|?|?|?|?|?|?|?|
                            // INCIDENT |?|?|?|?|?|
                            // ?|?|?|?|?|?|?|?|?|?|
                            
                            if incident.emergency {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(Color.red)
                                    .font(.footnote)
                            }
                        }
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                        .frame(alignment: .center)
                        
                        // <|><|><|><|>
                        // DIVIDER ><|>
                        // <|><|><|><|>
                        
                        if incidentId != incidentIds.last {
                            Divider()
                        }
                    }
                }
            }
            
            // ----------------------------------------------------------------
            // MODIFIERS //////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@ MARK: NAVIGATION
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            
            
            .navigationTitle("incidents")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarBackButtonHidden(false)
            .navigationSplitViewStyle(.automatic)
            
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@ MARK: TOOLBAR
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        router.pathCli.removeLast()
                    } label: {
                        Label("Home", systemImage: "house")
                    }
                }
            }
        }
        
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@> MARK: BACKGROUND
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@
        
        .background {
            if let imageId = veterinarian.imageId {
                AsyncImage(url: veterinarianGig.find(imageId: imageId)) { phase in
                    switch phase {
                        
                        // ------------
                        // EMPTY //////
                        // ------------
                        
                    case .empty:
                        ProgressView()
                        
                        // ------------
                        // SUCCESS ////
                        // ------------
                        
                    case .success(let returnedImage):
                        returnedImage
                            .resizable()
                            .overlay(.ultraThinMaterial)
                            .aspectRatio(contentMode: .fill)
                            .brightness(colorScheme == .light ? 0.2 : -0.1)
                        
                        // ------------
                        // FAILURE ////
                        // ------------
                        
                    case .failure:
                        Color.clear
                        
                        // ------------
                        // DEFAULT ////
                        // ------------
                        
                    default:
                        fatalError()
                    }
                }
            }
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct VeterinarianIncidentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            VeterinarianIncidentsView(veterinarian: VeterinarianGig.vet1, incidentIds: [IncidentGig.inc0.id, IncidentGig.inc1.id])
//                .environmentObject(Router())
//                .environmentObject(VeterinarianGig())
//                .environmentObject(IncidentGig())
//        }
//    }
//}
