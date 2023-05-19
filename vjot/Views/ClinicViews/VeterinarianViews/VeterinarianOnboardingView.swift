//
//  VeterinarianOnboardingView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 7/4/23.
//

import SwiftUI

struct VeterinarianOnboardingView: View {
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var incidentGig: IncidentGig
    
    @Binding var onboardingIsPresented: Bool
    
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
                        Text("welcome, sign up!")
                            .font(.title)
                            .foregroundColor(Color.primary)
                        Text("Fill in the form to join our crew.")
                            .font(.headline)
                            .foregroundColor(Color.secondary)
                    }
                    
                    // ------------------------------------
                    // REQUIRED SECTION /\/\/\/\/\/\/\/\/\/
                    // ------------------------------------
                    
                    Section {
                        TextField("Name", text: $nameText)
                            .textContentType(.name)
                            .keyboardType(.namePhonePad)
                    } header: {
                        Text("Required information")
                    } footer: {
                        Text("Name, nickname or handle, your preferred way to be addressed, especially under pressure. One character or more.")
                    }
                    
                    // ------------------------------------
                    // LOCATION SECTION /\/\/\/\/\/\/\/\/\
                    // ------------------------------------
                    
                    Section {
                        TextField("Address", text: $addressText)
                            .textContentType(.location)
                            .keyboardType(.default)
                        TextField("Post-Code", text: $postCodeText)
                            .textContentType(.location)
                            .keyboardType(.default)
                        TextField("City", text: $cityText)
                            .textContentType(.location)
                            .keyboardType(.default)
                        TextField("Country", text: $countryText)
                            .textContentType(.location)
                            .keyboardType(.default)
                    } header: {
                        Text("Optional location details")
                    } footer: {
                        Text("Keep bureaucracy in check, quicky forward medical supplies, coordinate our field efforts.")
                    }
                    
                    // ------------------------------------
                    // CONTACT SECTION /\/\/\/\/\/\/\/\/\/
                    // ------------------------------------
                    
                    Section {
                        TextField("Telephone Number", text: $telephoneNumberText)
                            .textContentType(.telephoneNumber)
                            .keyboardType(.phonePad)
                        TextField("Email Address", text: $emailAddressText)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                    } header: {
                        Text("Optional Contact Details")
                    } footer: {
                        Text("Prominent emergency communication assets in times of need, when seconds count and urgently reaching out gets crucial.")
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
                                        incidentIds.append(incident.id)
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
                    } header: {
                        Text("Pending Medical Incidents")
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
                            id: UUID(),
                            name: nameText,
                            address: (addressText == "") ? nil : addressText,
                            postCode: (postCodeText == "") ? nil : postCodeText,
                            city: (cityText == "") ? nil : cityText,
                            country: (countryText == "") ? nil : countryText,
                            telephoneNumber: (telephoneNumberText == "") ? nil : telephoneNumberText,
                            emailAddress: (emailAddressText == "") ? nil : emailAddressText,
                            incidentIds: incidentIds,
                            catFavs: [:],
                            dogFavs: [:],
                            catVotes: [:],
                            dogVotes: [:]
                        )
                        do {
                            try veterinarianGig.create(
                                veterianarian: veterinarian
                            )
                            try veterinarianGig.activate(veterinarian: veterinarian)
                            onboardingIsPresented.toggle()
                        } catch let error {
                            print(error.localizedDescription)
                            // VJotError ////////////////////////////////
                            vjotError = VJotError.error(error)
                            vjotErrorThrown.toggle()
                        }
                    } label: {
                        HStack {
                            Text("ONBOARD")
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(nameText.isEmpty)
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
                        onboardingIsPresented.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .padding()
                    }
                    .disabled(veterinarianGig.veterinarians.isEmpty)
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

extension VeterinarianOnboardingView {
    
}

// ------------------------------------------------------------------------
// ////////////////////////////////////////////////////////  MARK: SUBVIEWS
// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: PREVIEW
// ------------------------------------------------------------------------
//struct VeterinarianOnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        VeterinarianOnboardingView(onboardingIsPresented: Binding.constant(true))
//            .environmentObject(VeterinarianGig())
//            .environmentObject(IncidentGig())
//    }
//}

// void * _Nullable NSMapGet(NSMapTable * _Nonnull, const void * _Nullable): map table argument is NULL
// invalid mode 'kCFRunLoopCommonModes' provided to CFRunLoopRunSpecific - break on _CFRunLoopError_RunCalledWithInvalidMode to debug. This message will only appear once per execution.
// https://stackoverflow.com/questions/72321705/swiftui-issue-with-state-with-toggle-sheet
