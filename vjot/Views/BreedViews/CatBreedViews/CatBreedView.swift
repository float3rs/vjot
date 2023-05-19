//
//  CatBreedView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 12/4/23.
//

import SwiftUI
import MapKit

struct CatBreedView: View {
    var catBreed: CatAPIBreed
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var image: CatAPIImage? = nil
    
    @State var invalidLocation: Bool = false
    @State var analyses: [APIAnalysis] = []
    @State var goAnalyse: Bool = false
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        
        // --------------------------------------------------------------------
        // CONTENT ////////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        
        ScrollView {
            VStack {
                
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: THE NAME
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                VStack {
                    HStack {
                        Text("breed:")
                            .foregroundColor(Color.secondary)
                        Text(catBreed.name)
                            .foregroundColor(Color.primary)
                    }
                    .font(.title)
                    .multilineTextAlignment(.center)
                    
                    // //////////////////////////
                    // ALTERNATIVE NAMES ////////
                    // //////////////////////////
                    
                    if let altnames = catBreed.altNames {
                        if !altnames[0].isEmpty {
                            Divider()
                            VStack {
                                Text("alternatively:")
                                    .foregroundColor(Color.secondary)
                                ForEach(altnames, id: \.self) { name in
                                    Text(name)
                                        .foregroundColor(Color.primary)
                                }
                            }
                            .font(.body)
                        }
                    }
                }
                .padding()
                
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: THE IMAGE
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                if let image {
                    
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    
                    VStack(alignment: .center, spacing: 2) {
                        AsyncImage(url: image.url) { phase in
                            switch phase {
                                
                                // ------------------
                                // EMPTY ////////////
                                // ------------------
                                
                            case .empty:
                                EmptyView()
                                
                                // ------------------
                                // SUCCESS //////////
                                // ------------------
                                
                            case .success(let returnedImage):
                                returnedImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(15)
                                
                                // ------------------
                                // FAILURE //////////
                                // ------------------
                                
                            case .failure(_):
                                EmptyView()
                                
                                // ------------------
                                // DEFAULT //////////
                                // ------------------
                                
                            default:
                                fatalError()
                            }
                        }
                        
                        // <|><|><|><|><|><
                        // TAP |><|><|><|><
                        // <|><|><|><|><|><
                        
                        .onTapGesture { goAnalyse.toggle() }
                        
                        // <|><|><|><|><|><
                        // CAPTION ><|><|><
                        // <|><|><|><|><|><
                        
                        if let width = image.width {
                            if let height = image.height  {
                                HStack(spacing: 8) {
                                    HStack(spacing: 4) {
                                        Text("image id:")
                                            .foregroundColor(Color.secondary)
                                        Text(image.id)
                                            .foregroundColor(Color.primary)
                                    }
                                    .font(.caption)
                                    HStack(spacing: 4) {
                                        Text("resolution:")
                                            .foregroundColor(Color.secondary)
                                        HStack(spacing: 0) {
                                            Text("(")
                                                .foregroundColor(Color.secondary)
                                            Text(String(width))
                                                .foregroundColor(Color.primary)
                                            Text(" x ")
                                                .foregroundColor(Color.secondary)
                                            Text(String(height))
                                                .foregroundColor(Color.primary)
                                            Text(")")
                                                .foregroundColor(Color.secondary)
                                        }
                                    }
                                    .font(.caption)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                }
                
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: THE DETAILS
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                VStack(alignment: .center, spacing: 0) {
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(- MARK: DESCRIPTION
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if let description = catBreed.description {
                        VStack {
                            Text("description")
                                .foregroundColor(Color.secondary)
                                .font(.headline)
                            Text(description)
                                .foregroundColor(Color.primary)
                                .multilineTextAlignment(.leading)
                                .font(.body)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-) MARK: NAVIGATION
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    CatBreedNavLinkView(catBreed: catBreed)
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(- MARK: LOCATION
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if (
                        catBreed.origin != nil ||
                        catBreed.countryCodes != nil ||
                        catBreed.countryCode != nil
                    ) {
                        VStack(spacing: 0) {
                            
                            // <|><|><|><|><|><|>
                            // ORIGINS ><|><|><|>
                            // <|><|><|><|><|><|>
                            
                            if let origin = catBreed.origin {
                                if !origin.isEmpty {
                                    if origin[0] != "" {
                                        
                                        // ::::::::::::::::
                                        // IF SOME ::::::::
                                        // ::::::::::::::::
                                        
                                        HStack {
                                            Text("origin:")
                                                .foregroundColor(Color.secondary)
                                            HStack(spacing: 2) {
                                                Text("[")
                                                    .foregroundColor(Color.secondary)
                                                
                                                // //////////////////
                                                // FOR EACH /////////
                                                // //////////////////
                                                
                                                ForEach(origin, id: \.self) { code in
                                                    Text(code)
                                                        .foregroundColor(Color.primary)
                                                    if code != origin.last {
                                                        Text("|")
                                                            .foregroundColor(Color.secondary)
                                                    } else {
                                                        Text("]")
                                                            .foregroundColor(Color.secondary)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // <|><|><|><|><|><|>
                            // COUNTRY CODES ><|>
                            // <|><|><|><|><|><|>
                            
                            if let countryCodes = catBreed.countryCodes {
                                if !countryCodes.isEmpty {
                                    if countryCodes[0] != "" {
                                        
                                        // ::::::::::::::::
                                        // IF SOME ::::::::
                                        // ::::::::::::::::
                                        
                                        HStack {
                                            Text("country codes:")
                                                .foregroundColor(Color.secondary)
                                            HStack(spacing: 2) {
                                                Text("[")
                                                    .foregroundColor(Color.secondary)
                                                
                                                // //////////////////
                                                // FOR EACH /////////
                                                // //////////////////
                                                
                                                ForEach(countryCodes, id: \.self) { countryCode in
                                                    Text(countryCode)
                                                        .foregroundColor(Color.primary)
                                                    if countryCode != countryCodes.last {
                                                        Text("|")
                                                            .foregroundColor(Color.secondary)
                                                    } else {
                                                        Text("]")
                                                            .foregroundColor(Color.secondary)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // <|><|><|><|><|><|>
                            // COUNTRY CODE |><|>
                            // <|><|><|><|><|><|>
                            
                            if let countryCode = catBreed.countryCode {
                                VStack {
                                    HStack {
                                        Text("country code:")
                                            .foregroundColor(Color.secondary)
                                        Text(countryCode)
                                            .foregroundColor(Color.primary)
                                    }
                                    
                                    // [][][][][][][][][][][][][][][][][][][][]
                                    // [][][][][][][][][][][][][][][] MARK: MAP
                                    // [][][][][][][][][][][][][][][][][][][][]
                                    
                                    if let chosenLocation = chooseLocation() {
                                        
                                        // ::::::::::::::::
                                        // IF LOCATION ::::
                                        // ::::::::::::::::
                                        
                                        Button {
                                            let geocoder = CLGeocoder()
                                            geocoder.geocodeAddressString(chosenLocation) { (placemarks, error) in
                                                
                                                // ------------------
                                                // ERROR ////////////
                                                // ------------------
                                                
                                                if let error {
                                                    print(error.localizedDescription)
                                                    invalidLocation.toggle()
                                                }
                                                
                                                // ------------------
                                                // FOUND ////////////
                                                // ------------------
                                                
                                                if let placemarks {
                                                    let distance: CLLocationDistance = 10240000
                                                    if let coordinate: CLLocationCoordinate2D = placemarks.first?.location?.coordinate {
                                                        
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        // REGION }{}{}{}{}{}{}
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        
                                                        let region = MKCoordinateRegion(
                                                            center: coordinate,
                                                            latitudinalMeters: distance,
                                                            longitudinalMeters: distance
                                                        )
                                                        
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        // OPTIONS }{}{}{}{}{}{
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        
                                                        let options = [
                                                            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                                                            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
                                                        ]
                                                        
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        // PLACEMARK {}{}{}{}{}
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        
                                                        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                                                        
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        // ITEM }{}{}{}{}{}{}{}
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        
                                                        let mapItem = MKMapItem(placemark: placemark)
                                                        
                                                        mapItem.name = chosenLocation
                                                        mapItem.openInMaps(launchOptions: options)
                                                    }
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "map")
                                                .foregroundColor(Color.primary)
                                                .font(.headline)
                                        }
                                        .buttonStyle(.bordered)
                                        .padding()
                                    }
                                }
                            }
                            
                        }
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.bottom)
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(- MARK: TEMPERAMENT
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if let temperament = catBreed.temperament {
                        VStack {
                            Text("temperament")
                                .foregroundColor(Color.secondary)
                                .font(.body)
                            ForEach(temperament, id: \.self) { trait in
                                Text(trait)
                                    .foregroundColor(Color.primary)
                            }
                        }
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.bottom)
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-) MARK: METRICS
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    // https://stackoverflow.com/questions/62820488/extra-arguments-at-positions-11-12-in-call-swiftui LoLoLoLoLoL
                    
                    if (
                        catBreed.adaptability != nil ||
                        catBreed.energyLevel != nil ||
                        catBreed.affectionLevel != nil ||
                        catBreed.strangerFriendly != nil ||
                        catBreed.childFriendly != nil ||
                        catBreed.dogFriendly != nil ||
                        catBreed.catFriendly != nil ||
                        catBreed.grooming != nil ||
                        catBreed.healthIssues != nil ||
                        catBreed.intelligence != nil ||
                        catBreed.sheddingLevel != nil ||
                        catBreed.socialNeeds != nil ||
                        catBreed.vocalisation != nil ||
                        catBreed.bidability != nil
                    ) {
                        VStack(alignment: .trailing, spacing: 0) {
                            Group {
                                if let adaptability = catBreed.adaptability {
                                    HStack(alignment: .center) {
                                        Text("adaptability:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...adaptability, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(adaptability..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                                if let energyLevel = catBreed.energyLevel {
                                    HStack(alignment: .center) {
                                        Text("energy level:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...energyLevel, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(energyLevel..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                            }
                            Group {
                                if let affectionLevel = catBreed.affectionLevel {
                                    HStack(alignment: .center) {
                                        Text("affection level:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...affectionLevel, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(affectionLevel..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                                
                                if let strangerFriendly = catBreed.strangerFriendly {
                                    HStack(alignment: .center) {
                                        Text("stranger friendly:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...strangerFriendly, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(strangerFriendly..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                            }
                            Group {
                                if let childFriendly = catBreed.childFriendly {
                                    HStack(alignment: .center) {
                                        Text("child friendly:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...childFriendly, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(childFriendly..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                                if let dogFriendly = catBreed.dogFriendly {
                                    HStack(alignment: .center) {
                                        Text("dog friendly:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...dogFriendly, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(dogFriendly..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                            }
                            Group {
                                if let catFriendly = catBreed.catFriendly {
                                    HStack(alignment: .center) {
                                        Text("cat friendly:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...catFriendly, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(catFriendly..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                            }
                            if let grooming = catBreed.grooming {
                                HStack(alignment: .center) {
                                    Text("grooming:")
                                        .foregroundColor(Color.secondary)
                                    ForEach(1...grooming, id: \.self) { _ in
                                        Image(systemName: "square.fill")
                                            .foregroundColor(Color.primary)
                                    }
                                    ForEach(grooming..<5, id: \.self) { _ in
                                        Image(systemName: "square")
                                            .foregroundColor(Color.primary)
                                    }
                                }
                            }
                            Group {
                                if let healthIssues = catBreed.healthIssues {
                                    HStack(alignment: .center) {
                                        Text("health issues:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...healthIssues, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(healthIssues..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                                if let intelligence = catBreed.intelligence {
                                    HStack(alignment: .center) {
                                        Text("intelligence:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...intelligence, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(intelligence..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                            }
                            Group {
                                if let sheddingLevel = catBreed.sheddingLevel {
                                    HStack(alignment: .center) {
                                        Text("shedding level:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...sheddingLevel, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(sheddingLevel..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                                if let socialNeeds = catBreed.socialNeeds {
                                    HStack(alignment: .center) {
                                        Text("social needs:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...socialNeeds, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(socialNeeds..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                            }
                            Group {
                                if let vocalisation = catBreed.vocalisation {
                                    HStack(alignment: .center) {
                                        Text("vocalisation:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...vocalisation, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(vocalisation..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                                if let bidability = catBreed.bidability {
                                    HStack(alignment: .center) {
                                        Text("bidability:")
                                            .foregroundColor(Color.secondary)
                                        ForEach(1...bidability, id: \.self) { _ in
                                            Image(systemName: "square.fill")
                                                .foregroundColor(Color.primary)
                                        }
                                        ForEach(bidability..<5, id: \.self) { _ in
                                            Image(systemName: "square")
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                }
                            }
                        }
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.bottom)
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(- MARK: LIFESPAN
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if let lifespan = catBreed.lifeSpan {
                        HStack {
                            Text("lifespan:")
                                .foregroundColor(Color.secondary)
                            Text(String(lifespan.lowerBound))
                            Text("-")
                                .foregroundColor(Color.secondary)
                            Text(String(lifespan.upperBound))
                            Text("(years)")
                                .font(.footnote)
                                .foregroundColor(Color.secondary)
                        }
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.bottom)
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(- MARK: BOOLS
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if (
                        catBreed.indoor != nil ||
                        catBreed.lap != nil ||
                        catBreed.experimental != nil ||
                        catBreed.hairless != nil ||
                        catBreed.natural != nil ||
                        catBreed.rare != nil ||
                        catBreed.rex != nil ||
                        catBreed.suppressedTail != nil ||
                        catBreed.shortLegs != nil ||
                        catBreed.hypoallergenic != nil
                    ) {
                        VStack(alignment: .trailing, spacing: 0) {
                            Group {
                                if let indoor = catBreed.indoor {
                                    HStack {
                                        Text("indoor:")
                                            .foregroundColor(Color.secondary)
                                        if indoor {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.green)
                                        } else {
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color.red)
                                        }
                                    }
                                }
                                if let lap = catBreed.lap {
                                    HStack {
                                        Text("lap:")
                                            .foregroundColor(Color.secondary)
                                        if lap {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.green)
                                        } else {
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color.red)
                                        }
                                    }
                                }
                            }
                            Group{
                                if let experimental = catBreed.experimental {
                                    HStack {
                                        Text("experimental:")
                                            .foregroundColor(Color.secondary)
                                        if experimental {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.green)
                                        } else {
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color.red)
                                        }
                                    }
                                }
                                if let hairless = catBreed.hairless {
                                    HStack {
                                        Text("hairless:")
                                            .foregroundColor(Color.secondary)
                                        if hairless {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.green)
                                        } else {
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color.red)
                                        }
                                    }
                                }
                            }
                            Group {
                                if let natural = catBreed.natural {
                                    HStack {
                                        Text("natural:")
                                            .foregroundColor(Color.secondary)
                                        if natural {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.green)
                                        } else {
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color.red)
                                        }
                                    }
                                }
                                if let rare = catBreed.rare {
                                    HStack {
                                        Text("rare:")
                                            .foregroundColor(Color.secondary)
                                        if rare {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.green)
                                        } else {
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color.red)
                                        }
                                    }
                                }
                            }
                            Group {
                                if let rex = catBreed.rex {
                                    HStack {
                                        Text("rex:")
                                            .foregroundColor(Color.secondary)
                                        if rex {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.green)
                                        } else {
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color.red)
                                        }
                                    }
                                }
                                if let suppressedTail = catBreed.suppressedTail {
                                    HStack {
                                        Text("suppressed tail:")
                                            .foregroundColor(Color.secondary)
                                        if suppressedTail {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.green)
                                        } else {
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color.red)
                                        }
                                    }
                                }
                            }
                            Group {
                                if let shortLegs = catBreed.shortLegs {
                                    HStack {
                                        Text("short legs:")
                                            .foregroundColor(Color.secondary)
                                        if shortLegs {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.green)
                                        } else {
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color.red)
                                        }
                                    }
                                }
                                if let hypoallergenic = catBreed.hypoallergenic {
                                    HStack {
                                        Text("hypoallergenic:")
                                            .foregroundColor(Color.secondary)
                                        if hypoallergenic {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.green)
                                        } else {
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color.red)
                                        }
                                    }
                                }
                            }
                        }
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.bottom)
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-) MARK: BODY
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // WEIGHT /\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    
                    if let weight = catBreed.weight {
                        HStack(alignment: .center) {
                            
                            // ||||||||||||||||||
                            // LABEL ||||||||||||
                            // ||||||||||||||||||
                            
                            Text("weight:")
                                .foregroundColor(Color.secondary)
                            
                            // ||||||||||||||||||
                            // NUMBERS ||||||||||
                            // ||||||||||||||||||
                            
                            VStack(alignment: .vjotBreedH) {
                                
                                // ~@~@~@~@~@
                                // METRIC @~@
                                // ~@~@~@~@~@
                                
                                if let metric = weight.metric {
                                    HStack(alignment: .center) {
                                        Text(String(metric.lowerBound))
                                        Text("-")
                                            .foregroundColor(Color.secondary)
                                            .alignmentGuide(.vjotBreedH) { $0[.leading] }
                                        Text(String(metric.upperBound))
                                        Text("(kg)")
                                            .font(.footnote)
                                            .foregroundColor(Color.secondary)
                                    }
                                }
                                
                                // ~@~@~@~@~@
                                // IMPERIAL @
                                // ~@~@~@~@~@
                                
                                if let imperial = weight.imperial {
                                    HStack(alignment: .center) {
                                        Text(String(imperial.lowerBound))
                                        Text("-")
                                            .foregroundColor(Color.secondary)
                                            .alignmentGuide(.vjotBreedH) { $0[.leading] }
                                        Text(String(imperial.upperBound))
                                        Text("(lb)")
                                            .font(.footnote)
                                            .foregroundColor(Color.secondary)
                                    }
                                }
                            }
                            .foregroundColor(Color.primary)
                        }
                        .font(.body)
//                        .padding(.horizontal)
                        .padding(.bottom)
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
                    // <><><><><><><><><><><><><><><><><><><><>< MARK: FALLBACK
                    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
                    
                    if (
                        catBreed.temperament == nil &&
                        catBreed.origin == nil &&
                        catBreed.countryCodes == nil &&
                        catBreed.countryCode == nil &&
                        catBreed.description == nil &&
                        catBreed.lifeSpan == nil &&
                        catBreed.indoor == nil &&
                        catBreed.lap == nil &&
                        catBreed.altNames == nil &&
                        catBreed.adaptability == nil &&
                        catBreed.affectionLevel == nil &&
                        catBreed.childFriendly == nil &&
                        catBreed.dogFriendly == nil &&
                        catBreed.energyLevel == nil &&
                        catBreed.grooming == nil &&
                        catBreed.healthIssues == nil &&
                        catBreed.intelligence == nil &&
                        catBreed.sheddingLevel == nil &&
                        catBreed.socialNeeds == nil &&
                        catBreed.strangerFriendly == nil &&
                        catBreed.vocalisation == nil &&
                        catBreed.experimental == nil &&
                        catBreed.hairless == nil &&
                        catBreed.rare == nil &&
                        catBreed.rex == nil &&
                        catBreed.suppressedTail == nil &&
                        catBreed.shortLegs == nil &&
                        catBreed.hypoallergenic == nil &&
                        catBreed.catFriendly == nil &&
                        catBreed.bidability == nil
                    ) {
                        VStack{
                            Text("No details about this breed are available")
                            Text("Please consider carrying your own research")
                        }
                        .foregroundColor(Color.secondary)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .frame(alignment: .center)
                    }
                }
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .frame(alignment: .center)
            }
            
            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)
            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)( MARK: URLS
            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)
            
            if (
                catBreed.cfaUrl != nil ||
                catBreed.vetstreetUrl != nil ||
                catBreed.vcahospitalsUrl != nil ||
                catBreed.wikipediaUrl != nil
            ) {
                VStack(alignment: .trailing, spacing: 0) {
                    if let cfaUrl = catBreed.cfaUrl {
                        HStack {
                            Link(destination: cfaUrl) {
                                HStack {
                                    Text("Cat Fanciers' Association")
                                    Image(systemName: "link.circle")
                                }
                            }
                        }
                    }
                    if let vetstreetUrl = catBreed.vetstreetUrl {
                        Link(destination: vetstreetUrl) {
                            HStack {
                                Text("vetStreet")
                                Image(systemName: "link.circle")
                            }
                        }
                    }
                    if let vcahospitalsUrl = catBreed.cfaUrl {
                        
                        Link(destination: vcahospitalsUrl) {
                            HStack {
                                Text("VCA Animal Hospitals")
                                Image(systemName: "link.circle")
                            }
                        }
                    }
                    if let wikipediaUrl = catBreed.wikipediaUrl {
                        
                        Link(destination: wikipediaUrl) {
                            HStack {
                                Text("Wikipedia")
                                Image(systemName: "link.circle")
                            }
                        }
                    }
                }
                .font(.callout)
                .padding(.bottom)
            }
            
            Spacer()
            
            // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
            // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: THE FOOTER
            // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)
            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-) MARK: ID
            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)
            
            HStack {
                Text("breed id:")
                    .foregroundColor(Color.secondary)
                Text(catBreed.id)
                    .foregroundColor(Color.primary)
            }
            .font(.caption)
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // \!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!
        // \!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\! MARK: LOCATION ALERT
        // \!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!
        
        .alert(Text("Invalid Location"), isPresented: $invalidLocation, actions: {
            
        }, message: {
            Text("\(catBreed.countryCode ?? "ERROR") cannot be found on the map")
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
        
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@> MARK: BACKGROUND
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@
        
        .frame(maxWidth: .infinity)
        .background {
            if let image {
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                
                AsyncImage(url: image.url) { phase in
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
        
        // ^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%
        // ^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^% MARK: TOOLBAR
        // ^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if !router.pathBre.isEmpty {
                        router.pathBre.removeLast()
                    }
                } label: {
                    Label("BACK TO CATS", systemImage: "books.vertical")
                }
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: PURE MAGIC
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .task {
            if let imageId = catBreed.referenceImageId {
                do {
                    image = try await breedEngine.locateCat(
                        imageId: imageId,
                        veterinarianId: veterinarianGig.currentId
                    )
                } catch let error {
                    print(error.localizedDescription)
                    // VJotError ////////////////////////////////
                    vjotError = VJotError.error(error)
                    vjotErrorThrown.toggle()
                }
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+ MARK: ANALYSIS SHEET
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .sheet(isPresented: $goAnalyse) {
            if let image {
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                
                CatAnalysisSheetView(image: image, goAnalyze: $goAnalyse)
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
            }
        }
    }
    
    // ------------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////////
    // ------------------------------------------------------------------------
    
    func calculateRatio(width: Int?, height: Int?) -> CGFloat {
        switch verticalSizeClass {
        case .regular:
            guard let width = width, let height = height else { return ((1 + sqrt(5)) / 2) }
            return CGFloat(width) / CGFloat(height)
        case .compact:
            guard let width = width, let height = height else { return (1 + sqrt(5)) }
            return CGFloat(width) / CGFloat(height)
        case .none:
            return 1
        case .some(_):
            return 1
        }
    }
    
    // ------------------------------------------------------------------------
    
    func chooseLocation() -> String? {
        if let origin = catBreed.origin {
            if !origin.isEmpty {
                return origin.first!
            }
        } else {
            if let countryCode = catBreed.countryCode {
                return countryCode
            }
        }
        return nil
    }
}

// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%] MARK: NAVIGATION LINK
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][

struct CatBreedNavLinkView: View {
    var catBreed: CatAPIBreed
    
    var body: some View {
        NavigationLink {
            CatBreedImagesView(catBreed: catBreed)
        } label: {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.title3)
                .foregroundColor(Color.primary)
        }
        .buttonStyle(.bordered)
        .padding()
        .padding(.horizontal)
        .padding(.bottom)
        Divider()
            .padding(.horizontal)
            .padding(.bottom)
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatBreedView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatBreedView(catBreed: CatAPIBreed(id: "abys", name: "Abyssinian", referenceImageId: "0XYvRd7oD"))
//    }
//}
