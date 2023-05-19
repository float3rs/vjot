//
//  VeterinarianUpdateView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 8/4/23.
//

import SwiftUI

struct VeterinarianUpdateView: View {
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var incidentGig: IncidentGig
    
    @Binding var updateIsPresented: Bool
    
    @State var nameText: String = ""
    @State var addressText: String = ""
    @State var postCodeText: String = ""
    @State var cityText: String = ""
    @State var countryText: String = ""
    @State var telephoneNumberText: String = ""
    @State var emailAddressText: String = ""
    @State var incidentIds: [UUID] = []
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    @Binding var veterinarian: Veterinarian
    
    var body: some View {
        ZStack {
            
            // ----------------------------------------------------------------
            // FORM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            // ----------------------------------------------------------------
            
            VStack {
                Form {
                    
                    // ------------------------------------
                    // HEADLINE SECTION /\/\/\/\/\/\/\/\/\/
                    // ------------------------------------
                    
                    VStack(alignment: .center, spacing: 0) {
                        Text("edit your account")
                            .font(.title)
                            .foregroundColor(Color.secondary)
                        Text("Keep that information updated.")
                            .font(.headline)
                            .foregroundColor(Color.secondary)
                    }
                    
                    // ------------------------------------
                    // REQUIRED SECTION /\/\/\/\/\/\/\/\/\/
                    // ------------------------------------
                    
                    Section {
                        TextField("Name", text: $nameText, prompt: Text(veterinarian.name))
                            .textContentType(.name)
                            .keyboardType(.namePhonePad)
                    } header: {
                        Text("Required information")
                    } footer: {
                        Text("Names change, handles even more so. Update how you preferre be addressed. One character or more.")
//                        Text("Even one character is sufficient")
                    }
                    
                    // ------------------------------------
                    // LOCATION SECTION /\/\/\/\/\/\/\/\/\
                    // ------------------------------------
                    
                    Section {
                        TextField("Address", text: $addressText, prompt: Text(veterinarian.address ?? "Address"))
                            .textContentType(.location)
                            .keyboardType(.default)
                        TextField("Post-Code", text: $postCodeText, prompt: Text(veterinarian.postCode ?? "Post-Code"))
                            .textContentType(.location)
                            .keyboardType(.default)
                        TextField("City", text: $cityText, prompt: Text(veterinarian.city ?? "City"))
                            .textContentType(.location)
                            .keyboardType(.default)
                        TextField("Country", text: $countryText, prompt: Text(veterinarian.country ?? "Country"))
                            .textContentType(.location)
                            .keyboardType(.default)
                    } header: {
                        Text("Location Details")
                    } footer: {
                        Text("Changed your residential location? Provide us with the updated details for helping us keep bureaucracy in check.")
//                        Text("Keeping bureaucracy in check.")
                    }
                    
                    // ------------------------------------
                    // CONTACT SECTION /\/\/\/\/\/\/\/\/\/
                    // ------------------------------------
                    
                    Section {
                        TextField("Telephone Number", text: $telephoneNumberText, prompt: Text(veterinarian.telephoneNumber ?? "Telephone Number"))
                            .textContentType(.telephoneNumber)
                            .keyboardType(.phonePad)
                        TextField("Email Address", text: $emailAddressText, prompt: Text(veterinarian.emailAddress ?? "Email Address"))
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                    } header: {
                        Text("Optional Contact information")
                    } footer: {
//                        Text("Changed your contant information? Plese provide us with a means of communications when need arises and it gets crucial to reaching urgently.")
                        Text("Changed your contant information? Plese provide us with an updated means of communication.")
                    }
                    
                    // ------------------------------------
                    // INCIDENTS SECTION /\/\/\/\/\/\/\/\/\
                    // ------------------------------------
                    
                    Section {
                        List {
                            ForEach(incidentGig.incidents) { incident in
                                HStack {
                                    if incident.emergency {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(Color.red)
                                    } else {
                                        Image(systemName: "cross.circle.fill")
                                    }
                                    VStack(alignment: .leading) {
                                        Text(incident.description)
                                            .font(.callout)
                                        Text(incident.date.formatted(date: .abbreviated, time: .shortened))
                                            .font(.caption)
                                    }
                                    .padding(.horizontal)
                                }
                                .foregroundColor(incidentIds.contains(where: {$0 == incident.id}) ? Color.accentColor : Color.secondary)
                                    .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                                        Button {
                                            if !incidentIds.contains(where: { $0 == incident.id }) {
                                                incidentIds.append(incident.id)
                                            }
                                        } label: {
                                            Label("add", systemImage: "checkmark")
                                        }
                                        .tint(Color.accentColor)
                                        
                                    })
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                        Button {
                                            incidentIds = incidentIds.filter { $0 != incident.id }
                                        } label: {
                                            Label("remove", systemImage: "x.circle")
                                        }
                                        .tint(Color.red)
                                    })
                            }
                        }
                        .onAppear { incidentIds = veterinarian.incidentIds }
                    } header: {
                        Text("Pending Incidents")
                    } footer: {
                        VStack {
//                            Text("Our pending incidents. We will discuss them preferably on our daily on hands meeting at evening. If you are in charge for any of them, please assign them to yourself - designating responsibility and provide us with single point of reference if needed.")
                            Text("Take on clinical cases, designate responsibility and provide the team with a single point of reference.")
                        }
                    }
                    
                    // ------------------------------------
                    // BUTTON /\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // ------------------------------------
                    
                    Button {
                        let veterinarian = Veterinarian(
                            id: veterinarian.id,
                            name: (nameText == "") ? veterinarian.name : nameText,
                            address: (addressText == "") ? veterinarian.address : addressText,
                            postCode: (postCodeText == "") ? veterinarian.postCode : postCodeText,
                            city: (cityText == "") ? veterinarian.city : cityText,
                            country: (countryText == "") ? veterinarian.country : countryText,
                            telephoneNumber: (telephoneNumberText == "") ? veterinarian.telephoneNumber : telephoneNumberText,
                            emailAddress: (emailAddressText == "") ? veterinarian.emailAddress : emailAddressText,
                            imageId: veterinarian.imageId,
                            incidentIds: incidentIds,
                            catFavs: veterinarian.catFavs,
                            dogFavs: veterinarian.dogFavs,
                            catVotes: veterinarian.catVotes,
                            dogVotes: veterinarian.dogVotes
                        )
                        do {
                            try veterinarianGig.update(
                                veterinarian: veterinarian
                            )
                            updateIsPresented.toggle()
                        } catch let error {
                            print(error.localizedDescription)
                            // VJotError ////////////////////////////////
                            vjotError = VJotError.error(error)
                            vjotErrorThrown.toggle()
                        }
                    } label: {
                        HStack {
                            Text("UPDATE")
                            Image(systemName: "square.and.pencil.circle.fill")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
            
            // ----------------------------------------------------------------
            // DISMISS BUTTON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            // ----------------------------------------------------------------
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        updateIsPresented.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        
        // [][][[][][][][][][][][][][][][][][][][][][][
        // //////////////////////////////// ERROR ALERT
        // [][][[][][][][][][][][][][][][][][][][][][][
        
        .alert(isPresented: $vjotErrorThrown, error: vjotError) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            // Text(error.recoverySuggestion ?? "Try again later.")
            if let failureReason = error.failureReason {
                Text(failureReason)
            }
        }
    }
}

// ------------------------------------------------------------------------
// //////////////////////////////////////////////////////// MARK: EXTENSION
// ------------------------------------------------------------------------

extension VeterinarianUpdateView {
    
}

// ------------------------------------------------------------------------
// ////////////////////////////////////////////////////////  MARK: SUBVIEWS
// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: PREVIEW
// ------------------------------------------------------------------------
//struct VeterinarianUpdateView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            VeterinarianUpdateView(updateIsPresented: Binding.constant(true), veterinarian: Binding.constant(VeterinarianSession.vet1))
//                .environmentObject(VeterinarianSession())
//        }
//
//    }
//}
