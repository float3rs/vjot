//
//  VeterinarianAccountView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 8/4/23.
//

import SwiftUI
import PhotosUI
import MapKit

struct VeterinarianAccountView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    
    @State var updateIsPresented: Bool = false
    @State var veterinarian: Veterinarian
    
    @State var locationIsInvalid: Bool = false
    @State var telephoneNumberIsInvalid: Bool = false
    @State var emailAddressIsInvalid: Bool = false
    
    @State var photosPickerItem: PhotosPickerItem? = nil
    @State var contactImage: Image? = nil
    
    @State var size: CGSize = .zero
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ScrollView {
            
            // ----------------------------------------------------------------
            // CONTENT ////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            VStack(alignment: .center) {
                    
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][ MARK: NAME
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        Text("name:")
                            .foregroundColor(Color.secondary)
                        Text(veterinarian.name)
                            .foregroundColor(Color.primary)
                    }
                    .font(.body)
                    HStack {
                        Text("id:")
                            .foregroundColor(Color.secondary)
                        Text(veterinarian.id.uuidString)
                            .foregroundColor(Color.primary)
                    }
                    .font(.caption2)
                    
                }
                .multilineTextAlignment(.center)
                .padding()
                
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: IMAGE
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                if let contactImage {
                    
                    // ::::::::::::::::::::::::::
                    // IF ANY IMAGE EXISTS ::::::
                    // ::::::::::::::::::::::::::
                    
                    contactImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding()
                        .overlay(alignment: .bottomTrailing) {
                            
                            // <|><|><|><|><|><
                            // PICKER |><|><|><
                            // <|><|><|><|><|><
                            
                            PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
                                Image(systemName: "camera.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.title)
                                    .foregroundColor(.accentColor)
                                    .padding(.top)
                                    .padding(.top)
                                    .padding(.top)
                                    .padding(.top)
                                    .padding(.trailing)
                            }
                        }
                    
                } else {
                    
                    // ::::::::::::::::::::::::::::::::::::
                    // IF CONTACT IMAGE EXISTS ::::::::::::
                    // ::::::::::::::::::::::::::::::::::::
                    
                    if let uuid = veterinarian.imageId {
                        
                        // ::::::::::::::::::::::::::::::::
                        // IF CONTACT IMAGE EXISTS ::::::::
                        // ::::::::::::::::::::::::::::::::
                        
                        AsyncImage(url: veterinarianGig.find(imageId: uuid)) { phase in
                            switch phase {
                                
                                // --------------
                                // EMPTY ////////
                                // --------------
                                
                            case .empty:
                                ProgressView()
                                
                                // --------------
                                // SUCCESS //////
                                // --------------
                                
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                                    .padding()
                                
                                // --------------
                                // FAILURE //////
                                // --------------
                                
                            case .failure:
                                Image("sloth")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaledToFill()
                                    .clipped()
                                    .background()
                                
                                // --------------
                                // DEFAULT //////
                                // --------------
                                
                            default:
                                fatalError()
                            }
                        }
                        .overlay(alignment: .bottomTrailing) {
                            
                            // <|><|><|><|><|><|>
                            // PICKER |><|><|><|>
                            // <|><|><|><|><|><|>
                            
                            PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
                                Image(systemName: "camera.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.title)
                                    .foregroundColor(.accentColor)
                                    .padding(.top)
                                    .padding(.top)
                                    .padding(.top)
                                    .padding(.top)
                                    .padding(.trailing)
                            }
                        }
                        
                    } else {
                        
                        // ::::::::::::::::::::::::::::::::
                        // IF CONTACT IMAGE DOESN'T EXIST :
                        // ::::::::::::::::::::::::::::::::
                        
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(.horizontal)
                            .padding()
                            .frame(width: size.width / 2)
                            .overlay(alignment: .bottomTrailing) {
                                PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
                                    Image(systemName: "camera.circle.fill")
                                        .symbolRenderingMode(.multicolor)
                                        .font(.title)
                                        .foregroundColor(.accentColor)
                                        .padding(.top)
                                        .padding(.top)
                                        .padding(.top)
                                        .padding(.top)
                                        .padding(.trailing)
                                }
                            }
                    }
                }
            
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][ MARK: BUTTONS
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                VStack(alignment: .trailing) {
                    
                    // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
                    // LOCATE |><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
                    // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
                    // [][][][][][][][][][][][][][][][][][][][][][][]
                    // [][][][][][][][][][][][][][][][][][] MARK: MAP
                    // [][][][][][][][][][][][][][][][][][][][][][][]
                    
                    if let locationString = generateLocation(
                        address: veterinarian.address,
                        postCode: veterinarian.postCode,
                        city: veterinarian.city,
                        country: veterinarian.country
                    ){
                        
                        // ::::::::::::::::::::::
                        // IF LOCATION ::::::::::
                        // ::::::::::::::::::::::
                        
                        Button {
                            let geocoder = CLGeocoder()
                            geocoder.geocodeAddressString(locationString) { (placemarks, error) in
                                
                                // --------------
                                // ERROR ////////
                                // --------------
                                
                                if let error {
                                    print(error.localizedDescription)
                                    locationIsInvalid.toggle()
                                }
                                
                                // --------------
                                // FOUND ////////
                                // --------------
                                
                                if let placemarks {
                                    let distance: CLLocationDistance = 16384
                                    if let coordinate: CLLocationCoordinate2D = placemarks.first?.location?.coordinate {
                                        
                                        // {}{}{}{}{}{}{}{}
                                        // REGION }{}{}{}{}
                                        // {}{}{}{}{}{}{}{}
                                        
                                        let region = MKCoordinateRegion(
                                            center: coordinate,
                                            latitudinalMeters: distance,
                                            longitudinalMeters: distance
                                        )
                                        
                                        // {}{}{}{}{}{}{}{}
                                        // OPTIONS {}{}{}{}
                                        // {}{}{}{}{}{}{}{}
                                        
                                        let options = [
                                            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                                            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
                                        ]
                                        
                                        // {}{}{}{}{}{}{}{}
                                        // PLACEMARK {}{}{}
                                        // {}{}{}{}{}{}{}{}
                                        
                                        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                                        
                                        // {}{}{}{}{}{}{}{}
                                        // ITEM }{}{}{}{}{}
                                        // {}{}{}{}{}{}{}{}
                                        
                                        let mapItem = MKMapItem(placemark: placemark)
                                        
                                        mapItem.name = veterinarian.name
                                        mapItem.openInMaps(launchOptions: options)
                                    }
                                }
                            }
                        } label: {
                            HStack() {
                                Text("Locate")
                                Image(systemName: "map")
                            }
                            .font(.body)
                            .foregroundColor(Color.primary)
                            .buttonStyle(.bordered)
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical)
                        }
                        
                    } else {
                        
                        // ::::::::::::::::::::::
                        // IF NO LOCATION :::::::
                        // ::::::::::::::::::::::
                        
                        HStack() {
                            Text("Locate")
                            Image(systemName: "mappin.slash.circle")
                        }
                        .font(.body)
                        .foregroundColor(Color.secondary)
                        .multilineTextAlignment(.trailing)
                        .padding(.vertical)
                    }
                    
                    // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
                    // MAIL ><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
                    // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
                    
                    if let email = veterinarian.emailAddress {
                        
                        // ::::::::::::
                        // IF MAIL ::::
                        // ::::::::::::
                        
                        Button {
                            var mailURL: String = "mailto:"
                            mailURL.append(email)
                            guard let url = URL(string: mailURL) else { return }
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            } else {
                                emailAddressIsInvalid.toggle()
                            }
                            
                        } label: {
                            HStack() {
                                Text("Message")
                                Image(systemName: "message")
                            }
                            .font(.body)
                            .foregroundColor(Color.primary)
                            .buttonStyle(.bordered)
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical)
                        }
                        
                    } else {
                        
                        // ::::::::::::
                        // IF NO MAIL :
                        // ::::::::::::
                        
                        HStack() {
                            Text("Message")
                            Image(systemName: "location.slash")
                        }
                        .font(.body)
                        .foregroundColor(Color.secondary)
                        .multilineTextAlignment(.trailing)
                        .padding(.vertical)
                    }
                    
                    // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
                    // PHONE <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
                    // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
                    
                    if let phone = veterinarian.telephoneNumber {
                        Button {
                            var telURL: String = "tel://"
                            telURL.append(phone)
                            guard let url = URL(string: telURL) else { return }
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            } else {
                                telephoneNumberIsInvalid.toggle()
                            }
                        } label: {
                            HStack() {
                                Text("Phone")
                                Image(systemName: "phone")
                            }
                            .font(.body)
                            .foregroundColor(Color.primary)
                            .buttonStyle(.bordered)
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical)
                        }
                    } else {
                        HStack() {
                            Text("Phone")
                            Image(systemName: "iphone.slash")
                        }
                        .font(.body)
                        .foregroundColor(Color.secondary)
                        .multilineTextAlignment(.trailing)
                        .padding(.vertical)
                    }
                }
                
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][ MARK: DETAILS
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                VStack(alignment: .vjotVetdH, spacing: 0) {
                    if let address = veterinarian.address {
                        HStack {
                            Text("Address:")
                                .foregroundColor(Color.secondary)
                            Text(address)
                                .foregroundColor(Color.primary)
                                .alignmentGuide(.vjotVetdH) { $0[.leading] }
                        }
                    }
                    if let postCode = veterinarian.postCode {
                        HStack {
                            Text("Post-code:")
                                .foregroundColor(Color.secondary)
                            Text(postCode)
                                .foregroundColor(Color.primary)
                                .alignmentGuide(.vjotVetdH) { $0[.leading] }
                        }
                    }
                    if let city = veterinarian.city {
                        HStack {
                            Text("City:")
                                .foregroundColor(Color.secondary)
                            Text(city)
                                .foregroundColor(Color.primary)
                                .alignmentGuide(.vjotVetdH) { $0[.leading] }
                        }
                    }
                    if let country = veterinarian.country {
                        HStack {
                            Text("Country:")
                                .foregroundColor(Color.secondary)
                            Text(country)
                                .foregroundColor(Color.primary)
                                .alignmentGuide(.vjotVetdH) { $0[.leading] }
                        }
                    }
                    if let telephoneNumber = veterinarian.telephoneNumber {
                        HStack {
                            Text("Telephone number:")
                                .foregroundColor(Color.secondary)
                            Text(telephoneNumber)
                                .foregroundColor(Color.primary)
                                .alignmentGuide(.vjotVetdH) { $0[.leading] }
                        }
                    }
                    if let emailAddress = veterinarian.emailAddress {
                        HStack {
                            Text("Email address:")
                                .foregroundColor(Color.secondary)
                            Text(emailAddress)
                                .foregroundColor(Color.primary)
                                .alignmentGuide(.vjotVetdH) { $0[.leading] }
                        }
                    }
                    
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: FALLBACK
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    
                    if (
                        veterinarian.address == nil &&
                        veterinarian.postCode == nil &&
                        veterinarian.city == nil &&
                        veterinarian.country == nil &&
                        veterinarian.telephoneNumber == nil &&
                        veterinarian.emailAddress == nil
                    ) {
                        VStack{
                            Text("no optional details are available")
                            Text("please consider updating your account")
                        }
                        .foregroundColor(Color.secondary)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .frame(alignment: .center)
                    }
                }
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .frame(alignment: .center)
                
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: INCIDENTS
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                VStack(alignment: .trailing) {
                    if veterinarian.incidentIds.isEmpty {
                        
                        // ::::::::::::::::::::::
                        // IF INCIDENTS :::::::::
                        // ::::::::::::::::::::::
                        
                        HStack() {
                            Text("Incidents")
                            Image(systemName: "x.circle")
                        }
                        .font(.body)
                        .foregroundColor(Color.secondary)
                        .multilineTextAlignment(.trailing)
                        .padding(.vertical)
                        
                    } else {
                        
                        // ::::::::::::::::::::::
                        // IF NO INCIDENTS ::::::
                        // ::::::::::::::::::::::
                        
                        NavigationLink {
//                            VeterinarianIncidentsView(veterinarian: veterinarian, incidentIds: veterinarian.incidentIds)
                            IncidentHomeView(vetId: veterinarian.id)
                        } label: {
                            HStack() {
                                Text("Incidents")
                                Image(systemName: "arrow.right.circle")
                            }
                            .font(.body)
                            .foregroundColor(Color.primary)
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical)
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
            
//            .navigationTitle("account")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarBackButtonHidden(false)
            .navigationSplitViewStyle(.automatic)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        updateIsPresented.toggle()
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                            .font(.headline)
                    }
                }
            }
            
            // --------------------------------------------
            // GEOMETRY READER @@@@@@@@@@@@@@@@@@@@@@@@@@@@
            // --------------------------------------------
            
            GeometryReader { proxy in
                HStack {}
                    .onAppear {
                        size = proxy.size
                    }
            }
            
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@> MARK: ALERTS
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            // {}{}{}{}{}{}{}{}{}{}{}{}
            // ADDRESS {}{}{}{}{}{}{}{}
            // {}{}{}{}{}{}{}{}{}{}{}{}
            
            .alert(Text("Invalid address"), isPresented: $locationIsInvalid, actions: {
                
            }, message: {
                Text("\(generateLocation(address: veterinarian.address, postCode: veterinarian.postCode, city: veterinarian.city, country: veterinarian.country) ?? "ERROR") cannot be found on the map")
            })
            
            // {}{}{}{}{}{}{}{}{}{}{}{}
            // PHONE {}{}{}{}{}{}{}{}{}
            // {}{}{}{}{}{}{}{}{}{}{}{}
            
            .alert(Text("Invalid telephone number"), isPresented: $telephoneNumberIsInvalid, actions: {
                
            }, message: {
                Text("\(veterinarian.telephoneNumber ?? "ERROR") is no a valid telephone number")
            })
            
            // {}{}{}{}{}{}{}{}{}{}{}{}
            // TEXT }{}{}{}{}{}{}{}{}{}
            // {}{}{}{}{}{}{}{}{}{}{}{}
            
            .alert(Text("Invalid email address"), isPresented: $emailAddressIsInvalid, actions: {
                
            }, message: {
                Text("\(veterinarian.emailAddress ?? "ERROR") is not a valid email address")
            })
            
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@> MARK: UPDATE SHEET
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            
            .sheet(                                         // SUPER UGLY HACK TO UPDATE THE VIEW
                isPresented: $updateIsPresented,
                onDismiss: {
                    let index = veterinarianGig.veterinarians.firstIndex(where: {$0.id == veterinarian.id})
                    if let index {
                        veterinarian = veterinarianGig.veterinarians[index]
                    }
                }, content: {
                    VeterinarianUpdateView(updateIsPresented: $updateIsPresented, veterinarian: $veterinarian)
                }
            )
            
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@> MARK: ON CHANGE
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            
            .onChange(of: photosPickerItem) { newValue in
                Task {
                    let data: Data? = try? await photosPickerItem?.loadTransferable(type: Data.self)
                    if let data = data {
                        if let uiImage = UIImage(data: data) {
                            do {
                                try veterinarianGig.set(uiImage: uiImage, toVeterinarian: &veterinarian)
                            } catch let error {
                                print(error.localizedDescription)
                            }
                            contactImage = Image(uiImage: uiImage)
                            return
                        }
                    }
                }
            }
        }
        
        .frame(maxWidth: .infinity)
        
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@ MARK: BACKGROUND
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        
        .background {
            
            // ::::::::::::::::::::::::::::::::::::::::::::
            // IF CONTACT IMAGE EXISTS ::::::::::::::::::::
            // ::::::::::::::::::::::::::::::::::::::::::::
            
            if let contactImage {
                contactImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(.ultraThinMaterial)
                
            } else {
                
                // ::::::::::::::::::::::::::::::::::::::::
                // CONTACT IMAGE DOESN'T EXIST ::::::::::::
                // ::::::::::::::::::::::::::::::::::::::::
                // IF CONTACT HAS IMAGE :::::::::
                // ::::::::::::::::::::::::::::::
                
                if let uuid = veterinarian.imageId {
                    AsyncImage(url: veterinarianGig.find(imageId: uuid)) { phase in
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
                                .overlay(.thinMaterial)
                                .aspectRatio(contentMode: .fill)
                                .brightness(colorScheme == .light ? 0.1 : -0.1)
                            
                            // ------------------
                            // FAILURE //////////
                            // ------------------
                            
                        case .failure:
                            Color.clear
                            
                            // ------------------
                            // DEFAULT //////////
                            // ------------------
                            
                        default:
                            fatalError()
                        }
                    }
                }
            }
        }
    }
}

// ????????????????????????????????????????????????????????????????????????????
// ????????????????????????????????????????????????????????????????????????????
// ???????????????????????????????????????????????????????????? MARK: EXTENSION
// ????????????????????????????????????????????????????????????????????????????
// ????????????????????????????????????????????????????????????????????????????

extension VeterinarianAccountView {
    
    func generateLocation(address: String?, postCode: String?, city: String?, country: String?) -> String? {
        var location = String()
        if let address = address { location += address + " "}
        if let postCode = postCode { location += postCode + " " }
        if let city = city { location += city + " " }
        if let country = country { location += country}
        guard !location.isEmpty else { return nil }
        return location
    }
}


// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct VeterinarianAccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            VeterinarianAccountView(veterinarian: VeterinarianGig.vet1)
//                .environmentObject(VeterinarianGig())
//        }
//    }
//}

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-select-pictures-using-photospicker
// https://developer.apple.com/forums/thread/661144
//
// I AM GOING TO CONTINUE SCREAMING NOW...
//
// It's a known issue that the red flower image can't be selected using the simulator (63426347).The issue only affects the simulator environment so it should work on actual hardwares. If you want to continue using the simulator to test, you can select other images instead.
//
// via https://developer.apple.com/forums/thread/699155
