//
//  JotterView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 25/4/23.
//

import SwiftUI
import PhotosUI
import AVKit
import AVFoundation
import UIKit

struct JotterView: View {
    var function: Function? = nil
    var update: Incident? = nil
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var focusedDescription: Bool
    @FocusState private var focusedIdea: Bool
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var incidentGig: IncidentGig
    @EnvironmentObject var patientGig: PatientGig
    
    @State var incident: Incident?
    @State var emergency: Bool = false
    @State var snapURLs: [URL?] = []
    @State var tapes: [Tape] = []
    @State var tapesToDelete: [Tape] = []
    @State var ideaTextToAppend: String = String()
    @State var ideaCostToAppend: String = String()
    @State var ideaText: String = String()
    @State var ideaCost: String = String()
    @State var ideas: [Idea] = []
    @State var ideasToDelete: [Idea] = []
    
    @State var goSnap: Bool = false
    @State var goPatient: Bool = false
    
    @State var goPhoto: Bool = false
    @State var gonePhotoURL: URL = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc0a.jpg")!
    
    @State var description: String = String()
    @State var uuid: UUID = UUID()
    @State var photosPickerItem: PhotosPickerItem? = nil
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    @State private var image: UIImage?
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        
        // --------------------------------------------------------------------
        // CONTENT ////////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        
        //        NavigationStack(path: $router.pathJot) {
        NavigationView {
            ScrollView {
                
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-| MARK: TILTE
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                
                Text("jotter")
                    .foregroundColor(Color.primary)
                    .font(.largeTitle)
                    .padding()
                
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-| MARK: DESCRIPTION
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                
                VStack {
                    HStack(spacing: 0) {
                        
                        // ~~~~~~~~~~~~
                        // SPACER ~~~~~
                        // ~~~~~~~~~~~~
                        
                        Spacer()
                        
                        // ~~~~~~~~~~~~
                        // FIELD ~~~~~`
                        // ~~~~~~~~~~~~
                        
                        TextField("description", text: $description)
                            .focused($focusedDescription)
                            .textFieldStyle(.roundedBorder)
                            .font(.body)
                        //                            .disabled(description.contains(" "))
                            .padding()
                        
                        // ~~~~~~~~~~~~
                        // DISMISS ~~~~
                        // ~~~~~~~~~~~~
                        
                        Button {
                            focusedDescription = false // RELEASE THE KEYBOARD
                            if incident != nil {
                                incident!.description = description
                            }
                        } label: {
                            Image(systemName: "checkmark.rectangle")
                                .foregroundColor(Color.green)
                                .font(.title3)
                        }
                        .padding(.trailing)
                        
                        // ~~~~~~~~~~~~
                        // SPACER ~~~~~
                        // ~~~~~~~~~~~~
                        
                        Spacer()
                    }
                    .padding()
                }
                .padding(.vertical)
                
                // <:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:>
                // <:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:>
                // <:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:>
                
                Group {
                    Divider()
                        .foregroundColor(Color.primary)
                        .padding(.top, 20)
                    Text("SNAPS")
                        .foregroundColor(Color.secondary)
                        .font(.subheadline)
                        .padding(.top, 5)
                        .padding(.bottom, 15)
                }
                
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-| MARK: SNAPS
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                
                VStack {
                    VStack {
                        LazyVGrid(columns: [
                            .init(.flexible()),
                            .init(.flexible())
                        ]) {
                            
                            // (<>)(<>)(<>)(<>)(<>)(<
                            // (<>)(<>)(<>) LOOP URLS
                            // (<>)(<>)(<>)(<>)(<>)(<
                            
                            ForEach(Array(snapURLs), id: \.self) {url in
                                ZStack {
                                    
                                    // ////////////////////////////////////////////
                                    // ZSTACK FOR DELETE OVERLAY BUTTON LATER /////
                                    // ////////////////////////////////////////////
                                    
                                    NavigationLink {
                                        DeckardsPhotoInspector(incident: incident, url: url)
                                    } label: {
                                        AsyncImage(url: url) { phase in
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
                                                Rectangle()
                                                    .aspectRatio(
                                                        verticalSizeClass == .regular ? 1.0 : 16/9,
                                                        contentMode: .fit
                                                    )
                                                    .overlay {
                                                        returnedImage
                                                            .resizable()
                                                            .scaledToFill()
                                                            .clipped()
                                                    }
                                                    .clipShape(Rectangle())
                                                
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
                                    .disabled(function == Function.create)
                                    
                                    // ////////////////////////////////////////////
                                    // BUTTON OVERLAY FOR ZSTACK EARLIER ///////////
                                    // ////////////////////////////////////////////
                                    // [%][%][%][%][%][%]
                                    // ON DELETE? ][%][%]
                                    // [%][%][%][%][%][%]
                                    
                                    Button {
                                        if let url {
                                            do {
                                                try incidentGig.removeSnap(url: url, forIncident: &incident!)
                                            } catch {
                                                print(error.localizedDescription)
                                                // VJotError ////////////////////////
                                                vjotError = VJotError.error(error)
                                                vjotErrorThrown.toggle()
                                            }
                                            snapURLs = snapURLs.filter({ $0 != url })
                                            snapURLs = produceSnapURLs()
                                        }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(Color.red)
                                            .font(.title3)
                                    }
                                    
                                    // {}{}{}{}{}{}{}{}{}{}{}
                                    // GEOMETRY READER? {}{}{
                                    // {}{}{}{}{}{}{}{}{}{}{}
                                    
                                    .offset(x: verticalSizeClass == .regular ? 70 : 137, y: verticalSizeClass == .regular ? -70 : -75)
                                }
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    .padding()
                    
                    // (<>)(<>)(<>)(<>)(<>)(<
                    // (<>)(<>)(< PHOTOPICKER
                    // (<>)(<>)(<>)(<>)(<>)(<
                    
                    PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundColor(Color.green)
                            .font(.title2)
                    }
                    .padding()
                }
                .padding(.vertical, 20)
                
                //                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                //                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                //                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                //                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                //                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|- MARK: NAVIGATION DESTINATION
                //                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                //                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                //                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                //                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                //
                //                .navigationDestination(for: URL.self, destination: { url in
                //                    DeckardsPhotoInspector(url: url)
                //                })
                
                // <:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:>
                // <:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:>
                // <:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:>
                
                Group {
                    Divider()
                        .foregroundColor(Color.primary)
                        .padding(.top, 20)
                    Text("TAPES")
                        .foregroundColor(Color.secondary)
                        .font(.subheadline)
                        .padding(.top, 5)
                        .padding(.bottom, 15)
                }
                
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-| MARK: TAPES
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                
                VStack {
                    VStack {
                        LazyVGrid(columns: [
                            .init(.flexible())
                        ]) {
                            ForEach($tapes) { $tape in
                                VStack(alignment: .vjotIncH, spacing: 5) {
                                    HStack(alignment: .center) {
                                        
                                        // (<>)(<>)(<>)(<>)(<>)(<
                                        // (<>)(<>)(< DELETE TAPE
                                        // (<>)(<>)(<>)(<>)(<>)(<
                                        
                                        Button {
                                            tapesToDelete.append(tape)
                                        } label: {
                                            Image(systemName: "delete.left")
                                                .foregroundColor(Color.red)
                                                .font(.headline)
                                        }
                                        
                                        
                                        switch incidentGig.playing {
                                        case true:
                                            
                                            // ::::::::::::::::::::::::::::::::::::::::::::::::::::
                                            // ::: IF ANY TAPE PLAYING AND THIS IS NOT FOR DELETION
                                            // ::::::::::::::::::::::::::::::::::::::::::::::::::::
                                            
                                            Text(tape.date.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                                .foregroundColor(tape.playing && !tapesToDelete.contains(tape) ? Color.accentColor : Color.secondary)
                                                .monospaced()
                                                .kerning(-1)
                                                .font(.headline)
                                                .fontWeight(.ultraLight)
                                                .strikethrough(tapesToDelete.contains(tape), color: Color.red)
                                                .alignmentGuide(.vjotIncH) { $0[.trailing] }
                                            
                                        case false:
                                            
                                            // ::::::::::::::::::::::::::::::::::::::::::::::::::::
                                            // :::: IF NO TAPE PLAYING AND THIS IS NOT FOR DELETION
                                            // ::::::::::::::::::::::::::::::::::::::::::::::::::::
                                            
                                            Text(tape.date.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                                .foregroundColor(tapesToDelete.contains(tape) ? Color.secondary : Color.primary)
                                                .monospaced()
                                                .kerning(-1)
                                                .font(.headline)
                                                .fontWeight(.ultraLight)
                                                .strikethrough(tapesToDelete.contains(tape), color: Color.red)
                                                .alignmentGuide(.vjotIncH) { $0[.trailing] }
                                        }
                                        
                                        // (<>)(<>)(<>)(<>)(<>)(<
                                        // (<>)(<>)(<>) PLAY TAPE
                                        // (<>)(<>)(<>)(<>)(<>)(<
                                        
                                        Button {
                                            do {
                                                switch incidentGig.playing {
                                                case true:
                                                    
                                                    // &*&*&*&*&*&*&*&*&*&*&*&*
                                                    // ACT AS STOP BUTTON *&*&*
                                                    // &*&*&*&*&*&*&*&*&*&*&*&*
                                                    
                                                    incidentGig.playStop()
                                                    tape.playing = false
                                                    
                                                case false:
                                                    
                                                    // &*&*&*&*&*&*&*&*&*&*&*&*
                                                    // ACT AS STOP BUTTON *&*&*
                                                    // &*&*&*&*&*&*&*&*&*&*&*&*
                                                    
                                                    try incidentGig.play(tapeId: tape.id)
                                                    tape.playing = true
                                                }
                                            } catch {
                                                print(error.localizedDescription)
                                                // VJotError ////////////////////
                                                vjotError = VJotError.error(error)
                                                vjotErrorThrown.toggle()
                                            }
                                        } label: {
                                            switch incidentGig.recording {
                                            case true:
                                                
                                                // (_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)
                                                // APPEAR AS UNPLAYABLE RIGHT NOW _)(_)(_)
                                                // (_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)
                                                
                                                Image(systemName: "play.slash")
                                                    .foregroundColor(Color.secondary)
                                                    .font(.title3)
                                                
                                            case false:
                                                
                                                // (_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)
                                                // APPEAR AS PLAYABLE RIGHT NOW )(_)(_)(_)
                                                // (_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)
                                                
                                                switch tape.playing {
                                                case true:
                                                    
                                                    // ^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-
                                                    // APPEAR AS PLAYING RIGHT NOW ^-^-^-
                                                    // ^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-
                                                    
                                                    Image(systemName: "play.fill")
                                                        .foregroundColor(Color.green)
                                                        .font(.title3)
                                                    
                                                default:
                                                    
                                                    // ^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-
                                                    // APPEAR AS STANDBY RIGHT NOW ^-^-^-
                                                    // ^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-
                                                    
                                                    Image(systemName: "play")
                                                        .foregroundColor(incidentGig.playing ? Color.secondary : Color.green)
                                                        .font(.title3)
                                                }
                                            }
                                        }
                                        .disabled(incidentGig.recording || (!tape.playing && incidentGig.playing))
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .padding()
                    
                    // (<>)(<>)(<>)(<>)(<>)(<
                    // (<>)(<>) RECORD SWITCH
                    // (<>)(<>)(<>)(<>)(<>)(<
                    
                    Button {
                        do {
                            switch incidentGig.recording {
                            case true:
                                
                                // &*&*&*&*&*&*&*&*&*&*&*&*
                                // ACT AS STOP BUTTON *&*&*
                                // &*&*&*&*&*&*&*&*&*&*&*&*
                                
                                incidentGig.recStop()
                                if incident != nil {
                                    try incidentGig.appendTape(tapeId: uuid, toIncident: &incident!)
                                    tapes = produceTapes()
                                }
                                
                            case false:
                                
                                // &*&*&*&*&*&*&*&*&*&*&*&*
                                // ACT AS REC BUTTON &*&*&*
                                // &*&*&*&*&*&*&*&*&*&*&*&*
                                
                                uuid = try incidentGig.rec()
                            }
                        } catch {
                            print(error.localizedDescription)
                            // VJotError ////////////////////
                            vjotError = VJotError.error(error)
                            vjotErrorThrown.toggle()
                        }
                    } label: {
                        switch incidentGig.playing {
                        case true:
                            
                            // (_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)
                            // APPEAR AS UNRECORDABLE RIGHT NOW (_)(_)
                            // (_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)
                            
                            Image(systemName: "waveform.slash")
                                .foregroundColor(Color.secondary)
                                .font(.title)
                        case false:
                            
                            // (_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)
                            // APPEAR AS RECORDABLE RIGHT NOW _)(_)(_)
                            // (_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)(_)
                            
                            switch incidentGig.recording {
                            case true:
                                
                                // ^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-
                                // APPEAR AS RECORDING RIGHT NOW ^-^-
                                // ^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-
                                
                                Image(systemName: "waveform.circle.fill")
                                    .foregroundColor(Color.red)
                                    .font(.title)
                                
                                // ^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-
                                // APPEAR AS STANDBY RIGHT NOW ^-^-^~
                                // ^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-
                                
                            case false:
                                Image(systemName: "waveform")
                                    .foregroundColor(Color.green)
                                    .font(.title)
                            }
                        }
                        
                    }
                    .disabled(incidentGig.playing)
                    .padding()
                }
                .padding(.vertical, 20)
                
                // <:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:>
                // <:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:>
                // <:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:><:>
                
                Group {
                    Divider()
                        .foregroundColor(Color.primary)
                        .padding(.top, 20)
                    Text("IDEAS")
                        .foregroundColor(Color.secondary)
                        .font(.subheadline)
                        .padding(.top, 5)
                        .padding(.bottom, 15)
                }
                
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-| MARK: IDEAS
                // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                
                VStack {
                    LazyVGrid(columns: [
                        .init(.flexible())
                    ]) {
                        VStack(alignment: .vjotIncH, spacing: 0) {
                            
                            // (<>)(<>)(<>)(<>)(<>)(<
                            // (<>)(<>)(<> LOOP IDEAS
                            // (<>)(<>)(<>)(<>)(<>)(<
                            
                            ForEach($ideas) { $idea in
                                VStack(alignment: .trailing, spacing: 0) {
                                    HStack(alignment: .center, spacing: 0) {
                                        
                                        // {}{}{}{}{}{}{}{}{}{}{}{
                                        // IDEA STRING {}{}{}{}{}{
                                        // {}{}{}{}{}{}{}{}{}{}{}{
                                        
//                                        if let textString = incidentGig.find(ideaId: idea.id).0 {
                                            Text(attrstr(idea: idea))
                                                .foregroundColor(ideasToDelete.contains(idea) ? Color.secondary : Color.primary )
                                                .fontWeight(.light)
                                                .multilineTextAlignment(.leading)
                                            //                                                .monospaced()
                                                .kerning(0)
                                                .font(.subheadline)
                                                .lineSpacing(-10)
                                                .strikethrough(ideasToDelete.contains(idea), color: Color.red)
                                                .alignmentGuide(.vjotIncH) { $0[.trailing] }
//                                        }
                                        
                                        // {}{}{}{}{}{}{}{}{}{}{}{
                                        // MARKED TO DELETE BUTTON
                                        // {}{}{}{}{}{}{}{}{}{}{}{
                                        
                                        Button {
                                            ideasToDelete.append(idea)
                                        } label: {
                                            Image(systemName: "xmark.rectangle")
                                                .foregroundColor(Color.red)
                                                .font(.title3)
                                        }
                                        .padding(.leading)
                                    }
                                }
                                
                                // //////////////
                                // DIVIDER //////
                                // //////////////
                                
                                if idea != ideas.last {
                                    Divider()
                                        .padding(5)
                                        .hidden()
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.trailing, 45)
                    
                    GeometryReader { proxy in
                        HStack(alignment: .center, spacing: 0) {
                            
                            // ~~~~~~~~~~~~
                            // SPACER ~~~~~
                            // ~~~~~~~~~~~~
                            
                            Spacer()
                            
                            // ~~~~~~~~~~~~
                            // FIELD ~~~~~`
                            // ~~~~~~~~~~~~
                            
                            
                            VStack(alignment: .trailing, spacing: 0) {
                                
                                TextField("action", text: $ideaText)
                                    .focused($focusedIdea)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.body)
                                    .padding(.horizontal)
                                TextField("cost", text: $ideaCost)
                                    .keyboardType(.decimalPad)
                                    .focused($focusedIdea)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.body)
                                    .padding(.horizontal)
                                    .frame(width: proxy.size.width / 3)
                            }
                            
                            // #-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_
                            // REMOVE FOCUS FROM KEYBOARD _#-&_
                            // #-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_
                            // ~~~~~~~~~~~~
                            // DISMISS ~~~~
                            // ~~~~~~~~~~~~
                            
                            Button {
                                focusedIdea = false // RELEASE THE KEYBOARD
                                ideaTextToAppend = ideaText
                                ideaCostToAppend = ideaCost
                            } label: {
                                Image(systemName: "checkmark.rectangle")
                                    .foregroundColor(Color.green)
                                    .font(.title3)
                            }
                            .padding(.trailing)
                            
                            // ~~~~~~~~~~~~
                            // SPACER ~~~~~
                            // ~~~~~~~~~~~~
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .padding(.vertical, 20)
                    .padding(.bottom, 20)
                }
                .padding(.vertical, 20)
                
                // //////////////
                // DIVIDER //////
                // //////////////
                
                Divider()
                    .foregroundColor(Color.primary)
                    .padding(20)
                
                VStack {
                    
                    // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                    // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-| MARK: EMERGENCY
                    // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                    
                    Toggle(isOn: $emergency) {
                        switch emergency {
                        case true:
                            Image(systemName: colorScheme == .light ? "exclamationmark.triangle.fill" : "exclamationmark.triangle.fill")
                                .foregroundColor(colorScheme == .light ? Color.red : Color.yellow)
                                .font(.title)
                        case false:
                            Image(systemName: colorScheme == .light ? "triangle" : "triangle")
                                .foregroundColor(colorScheme == .light ? Color.yellow : Color.red)
                                .font(.title)
                        }
                        
                    }
                    .toggleStyle(.button)
                    .buttonStyle(.borderless)
                    .padding()
                    
                    // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                    // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-| MARK: PATIENTS
                    // -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                    
                    Group {
                        if let incident {
                            if let patientId = incident.patientId  {
                                if let patient = patientGig.track(currentId: patientId) {
                                    
                                    // ::::::::::::::::::::::::::::::::::::::::
                                    // IF PATIENT IS ASSOCIATED WITH INCIDENT :
                                    // ::::::::::::::::::::::::::::::::::::::::
                                    
                                    Button {
                                        goPatient.toggle()
                                    } label: {
                                        VStack(spacing: -5) {
                                            Text("associated patient")
                                                .foregroundColor(Color.primary)
                                            Text(patientGig.designate(patient: patient))
                                                .foregroundColor(Color.accentColor)
                                        }
                                        .padding()
                                    }
                                }
                                
                            } else {
                                
                                // ::::::::::::::::::::::::::::::::::::::::
                                // IF PATIENT IS NOT ASSOCIATED WITH ::::::
                                // INCIDENT, GET HIM TO CHOOOSE ONE :::::::
                                // ::::::::::::::::::::::::::::::::::::::::
                                
                                Button {
                                    goPatient.toggle()
                                } label: {
                                    VStack {
                                        VStack(spacing: -5) {
                                            Text("associated")
                                                .fontWeight(.light)
                                                .foregroundColor(Color.primary)
                                            Text("patient")
                                                .fontWeight(.light)
                                                .foregroundColor(Color.primary)
                                        }
                                        Image(systemName: "arrow.right.circle")
                                            .foregroundColor(Color.accentColor)
                                            .font(.title3)
                                    }
                                    .padding()
                                    .padding(.top, 20)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                
            } // SCROLLVIEW
            
            // %$%$%$%$%$%$%$%$%$%$%$%$
            // CURRENT USER? %$%$%$%$%$
            // %$%$%$%$%$%$%$%$%$%$%$%$
            
            //            WarningPatFotterView()
            //            WarningIncFooterView()
            //            WarningVetFooterView()
            
            // {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
            // {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: BACKGROUND
            // {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
            
            .background {
                switch emergency {
                case true:
                    colorScheme == .light ? Color.yellow.brightness(+0.5) : Color.red.brightness(-0.5)
                case false:
                    
                    if let incident {
                        if !incident.snaps.isEmpty {
                            if let url = incidentGig.find(snapId: incident.snaps[0].id) {
                                
                                
                                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                                // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                                
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                        
                                        // ------------
                                        // EMPTY //////
                                        // ------------
                                        
                                    case .empty:
                                        EmptyView()
                                        
                                        // ------------
                                        // SUCCESS ////
                                        // ------------
                                        
                                    case .success(let returnedImage):
                                        returnedImage
                                            .resizable()
                                            .overlay(.thinMaterial)
                                            .aspectRatio(contentMode: .fill)
                                            .brightness(colorScheme == .light ? 0.1 : -0.1)
                                        
                                        // ------------
                                        // FAILURE ////
                                        // ------------
                                        
                                    case .failure(_):
                                        Color.clear
                                        
                                        // ------------
                                        // DEFAULT ////
                                        // ------------
                                        
                                    default:
                                        fatalError()
                                    }
                                }
                                
                                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                                // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                            }
                        }
                    }
                }
            }
            
        } // OUTER VSTACK
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // #-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_
        // #-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_ MARK: SHEET
        // #-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_#-&_
        
        
        .sheet(isPresented: $goPatient, onDismiss: {
            if incident != nil {
                do {
                    try incidentGig.update(incident: incident!)
                } catch {
                    print(error.localizedDescription)
                    // VJotError ////////////////////////
                    vjotError = VJotError.error(error)
                    vjotErrorThrown.toggle()
                }
            }
        }, content: {
            JotterPatientView(goPatient: $goPatient, incident: $incident)
        })
        
        // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
        // [][][][][][][][][][][][][][][][][][][][][][][][][] MARK: ERROR ALERT
        // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
        
        .alert(isPresented: $vjotErrorThrown, error: vjotError) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            if let failureReason = error.failureReason {
                Text(failureReason)
            }
        }
        
        // {*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{
        // {*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*} MARK: ON CHANGE
        // {*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{*}{
        
        .onChange(of: photosPickerItem) { _ in
            Task {
                let data: Data? = try? await photosPickerItem?.loadTransferable(type: Data.self)
                if let data = data {
                    if let uiImage = UIImage(data: data) {
                        do {
                            if incident != nil {
                                try incidentGig.appendSnap(uiImage: uiImage, toIncident: &incident!)
                                snapURLs = produceSnapURLs()
                            }
                        } catch let error {
                            print(error.localizedDescription)
                            // VJotError ////////////////////////
                            vjotError = VJotError.error(error)
                            vjotErrorThrown.toggle()
                        }
                    }
                }
            }
        }
        
        .onChange(of: emergency) { newValue in
            if incident != nil {
                do {
                    incident?.emergency = emergency
                    try incidentGig.update(incident: incident!)
                } catch {
                    print(error.localizedDescription)
                    // VJotError ////////////////////////
                    vjotError = VJotError.error(error)
                    vjotErrorThrown.toggle()
                }
            }
        }
        
        .onChange(of: description) { newValue in
            if incident != nil {
                do {
                    if !description.isEmpty {
                        incident!.description = description
                        try incidentGig.update(incident: incident!)
                    } else {
                        incident!.description = ""
                        try incidentGig.update(incident: incident!)
                    }
                } catch {
                    print(error.localizedDescription)
                    // VJotError ////////////////////////
                    vjotError = VJotError.error(error)
                    vjotErrorThrown.toggle()
                }
            }
        }
        
        .onChange(of: tapesToDelete) { newValue in
            for tape in tapesToDelete {
                if incident != nil {
                    incident!.tapes = incident!.tapes.filter({$0.id != tape.id})
                    do {
                        try incidentGig.update(incident: incident!)
                    } catch {
                        print(error.localizedDescription)
                        // VJotError ////////////////////////
                        vjotError = VJotError.error(error)
                        vjotErrorThrown.toggle()
                    }
                }
            }
        }
        
        .onChange(of: ideasToDelete) { newValue in
            for idea in ideasToDelete {
                if incident != nil {
                    incident!.ideas = incident!.ideas.filter({$0.id != idea.id})
                    do {
                        try incidentGig.update(incident: incident!)
                    } catch {
                        print(error.localizedDescription)
                        // VJotError ////////////////////////
                        vjotError = VJotError.error(error)
                        vjotErrorThrown.toggle()
                    }
                }
            }
        }
        
        .onChange(of: ideaTextToAppend) { newValue in
            if incident != nil {
                do {
                    if !ideaTextToAppend.isEmpty {
                        try incidentGig.appendIdea(text: ideaTextToAppend, cost: ideaCostToAppend, toIncident: &incident!)
                        ideas = produceIdeas()
                    }
                } catch {
                    print(error.localizedDescription)
                    // VJotError ////////////////////////
                    vjotError = VJotError.error(error)
                    vjotErrorThrown.toggle()
                }
            }
        }
        
        
        // %|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|
        // %|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%| MARK: ON APPEAR
        // %|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|
        
        .onAppear {
            switch function {
            case .create:
                let newIncident = Incident(
                    id: UUID(),
                    description: "",
                    date: Date(),
                    ideas: [],
                    snaps: [],
                    tapes: [],
                    patientId: nil,
                    emergency: false
                )
                do {
                    try incidentGig.create(incident: newIncident)
                    incident = newIncident
                    incidentGig.currentId = incident?.id
                    snapURLs = produceSnapURLs()
                    description = incident!.description
                    tapes = produceTapes()
                    ideas = produceIdeas()
                } catch {
                    print(error.localizedDescription)
                    // VJotError ////////////////////////
                    vjotError = VJotError.error(error)
                    vjotErrorThrown.toggle()
                }
            case .update:
                if incident != nil {
                    snapURLs = produceSnapURLs()
                    tapes = produceTapes()
                    ideas = produceIdeas()
                    description = incident!.description
                    emergency = incident!.emergency
                }
            default:
                if let currentId = incidentGig.currentId {
                    if let currentInt = incidentGig.track(currentId: currentId) {
                        incident = currentInt
                        snapURLs = produceSnapURLs()
                        description = incident!.description
                        tapes = produceTapes()
                        ideas = produceIdeas()
                    }
                } else {
                    let newIncident = Incident(
                        id: UUID(),
                        description: "",
                        date: Date(),
                        ideas: [],
                        snaps: [],
                        tapes: [],
                        patientId: nil,
                        emergency: false
                    )
                    do {
                        try incidentGig.create(incident: newIncident)
                        incident = newIncident
                        incidentGig.currentId = incident?.id
                        snapURLs = produceSnapURLs()
                        tapes = produceTapes()
                        ideas = produceIdeas()
                    } catch {
                        print(error.localizedDescription)
                        // VJotError ////////////////////////
                        vjotError = VJotError.error(error)
                        vjotErrorThrown.toggle()
                    }
                }
            }
        }
        
        // %|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|
        // %|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|% MARK: ON DISAPPEAR
        // %|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|%|
        
        .onDisappear {
            if incidentGig.currentId == nil {
                incidentGig.currentId = incident?.id
            }
            if let incident {
                if let currentId = veterinarianGig.currentId {
                    if var curretVet = veterinarianGig.track(currentId: currentId) {
                        curretVet.incidentIds.append(incident.id)
                    }
                }
            }
        }
        
        // {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
        // {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{} MARK: SHEET
        // {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
        
        //        .sheet(isPresented: $goPhoto, onDismiss: {
        //
        //        }, content: {
        //            ZStack {
        //                AsyncImage(url: gonePhotoURL) { phase in
        //                switch phase {
        //
        //                    // ------------
        //                    // EMPTY //////
        //                    // ------------
        //
        //                case .empty:
        //                    ProgressView()
        //                    // ------------
        //                    // SUCCESS ////
        //                    // ------------
        //
        //                case .success(let returnedImage):
        //                    returnedImage
        //                        .resizable()
        //                        .scaledToFit()
        //
        //                    // ------------
        //                    // FAILURE ////
        //                    // ------------
        //
        //                case .failure:
        //                    Color.clear
        //
        //                    // ------------
        //                    // DEFAULT ////
        //                    // ------------
        //
        //                default:
        //                    fatalError()
        //                }
        //            }
        //
        //                // <|><|><|><|><|><|><|><|>
        //                // DISMISS BUTTON <|><|><|>
        //                // <|><|><|><|><|><|><|><|>
        //
        //                VStack {
        //                    HStack {
        //
        //                        // {-}{-}{-}{-}{-}{
        //                        // HSPACER }{-}{-}{
        //                        // {-}{-}{-}{-}{-}{
        //
        //                        Spacer()
        //
        //                        // {-}{-}{-}{-}{-}{
        //                        // BUTTON -}{-}{-}{
        //                        // {-}{-}{-}{-}{-}{
        //
        //                        Button {
        //                            goPhoto.toggle()
        //                        } label: {
        //                            Image(systemName: "xmark")
        //                                .font(.headline)
        //                                .padding()
        //                        }
        //                    }
        //
        //                    // {-}{-}{-}{
        //                    // VSPACER }{
        //                    // {-}{-}{-}{
        //
        //                    Spacer()
        //                }
        //            }
        //        })
        
    } // BODY
    
    // ------------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////////
    // ------------------------------------------------------------------------
    // [§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§]
    // [§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][ MARK: SNAPS PRODUCTION
    // [§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§]
    
    func produceSnapURLs() -> [URL?] {
        var snapURLss: [URL?] = []
        if let incident {
            incident.snaps.forEach { snap in
                snapURLss.append(incidentGig.find(snapId: snap.id))
            }
        }
        return snapURLss
    }
    
    // [§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§]
    // [§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][ MARK: TAPES PRODUCTION
    // [§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§]
    
    func produceTapes() -> [Tape] {
        if let incident {
            return incident.tapes
        }
        return []
    }
    
    // [§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§]
    // [§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][ MARK: IDEAS PRODUCTION
    // [§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§][§]
    
    func produceIdeas() -> [Idea] {
        if let incident {
            return incident.ideas
        }
        return []
    }
    
    // {-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}
    // {-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{- MARK: SHAPING ATTRSTR
    // {-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}
    
    func attrstr(idea: Idea) -> AttributedString {
        var attrstr = AttributedString()
        if let textString = incidentGig.find(ideaId: idea.id).0 {
            attrstr = AttributedString(textString)
            let text = attrstr.range(of: textString)!
            attrstr[text].foregroundColor = Color.primary
//            if var costString = incidentGig.find(ideaId: idea.id).1 {
            if let costString = incidentGig.find(ideaId: idea.id).1 {
                if !costString.isEmpty {
//                    costString = " €" + costString
//                    attrstr += AttributedString(costString)
//                    let cost = attrstr.range(of: costString)!
//                    attrstr[cost].foregroundColor = Color.secondary
                    let costDecimal = Decimal(string: costString, locale: .current)
                    let cst = Cost(costDecimal!)
                    if var cststr = cst.string {
                        cststr = " " + cststr
                        attrstr += AttributedString(cststr)
                        let cost = attrstr.range(of: cststr)!
                        attrstr[cost].foregroundColor = Color.secondary
                    }
                }
            }
        }
        return attrstr
    }
}

// |/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/
// |/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/| MARK: ENCHANCE
// |/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/
// |/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/| https://youtu.be/hHwjceFcF2Q

struct DeckardsPhotoInspector: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var incident: Incident?
    var url: URL?
    
    var body: some View {
        VStack {
            
            // \/\/\/\/\/\/\/
            // SPACER \/\/\/\
            // \/\/\/\/\/\/\/
            
            Spacer()
            
            // \/\/\/\/\/\/\/
            // IMAGE \/\/\/\/
            // \/\/\/\/\/\/\/
            
            AsyncImage(url: url) { phase in
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
                        .scaledToFit()
                    
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
            
            // \/\/\/\/\/\/\/
            // SPACER \/\/\/\
            // \/\/\/\/\/\/\/
            
            Spacer()
        }
        .background {
            AsyncImage(url: url) { phase in
                switch phase {
                    
                    // ------------
                    // EMPTY //////
                    // ------------
                    
                case .empty:
                    EmptyView()
                    
                    // ------------
                    // SUCCESS ////
                    // ------------
                    
                case .success(let returnedImage):
                    returnedImage
                        .resizable()
                        .overlay(.thinMaterial)
                        .aspectRatio(contentMode: .fill)
                        .brightness(colorScheme == .light ? 0.1 : -0.1)
                    
                    // ------------
                    // FAILURE ////
                    // ------------
                    
                case .failure(_):
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

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct JotterView_Previews: PreviewProvider {
//    static var previews: some View {
//        JotterView()
//    }
//}
