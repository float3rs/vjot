//
//  PatientCreateView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 27/4/23.
//

import SwiftUI
import PhotosUI

struct PatientCreateView: View {
    
    @EnvironmentObject var patientGig: PatientGig
    @EnvironmentObject var guardianGig: GuardianGig
    @EnvironmentObject var breedEngine: BreedEngine
    
//    @State var patient: Patient     // @State FOR CREATION
    @Binding var goCreate: Bool
    
    @State var guardianId: UUID?
    @State var notes: String = String()
    
    @State var photosPickerItem: PhotosPickerItem? = nil
    @State var picture: Image? = nil
    @State var uiImage: UIImage? = nil
    
    // detailsOfOwnership
    
    @State var ownerName0: String = String()
    @State var ownerSurname0: String = String()
    @State var ownerAddres0: String = String()
    @State var ownerPostCode0: String = String()
    @State var ownerCity0: String = String()
    @State var ownerCountry0: String = String()
    @State var ownerTelephoneNumber0: String = String()
    // --------------------------------
    @State var ownerName1: String = String()
    @State var ownerSurname1: String = String()
    @State var ownerAddres1: String = String()
    @State var ownerPostCode1: String = String()
    @State var ownerCity1: String = String()
    @State var ownerCountry1: String = String()
    @State var ownerTelephoneNumber1: String = String()
    
    // descriptionOfAnimal
    
    @State var pictureId: UUID = UUID()
    @State var name: String = String()
    @State var species: Species = .cat
    @State var breed: String = String()
    @State var sex: Sex = .female
    @State var dateOfBirth: Date = Date(timeIntervalSince1970: TimeInterval(0))
    @State var colour: Color = Color(red: 0.5, green: 0.5, blue: 0.5)
    @State var notableOrDiscernableFeaturesOrCharacteristics: String = String()
    
    // markingOfAnimal
    
    @State var transponderAlphanumericCode: String = String()
    @State var dateOfApplicationOrReadingOfTheTransponder: Date = Date(timeIntervalSince1970: TimeInterval(0))
    @State var locationOfTheTransponder: String = String()
    @State var tattooAlphanumericCode: String = String()
    @State var dateOfApplicationOrReadingOfTheTattoo: Date = Date(timeIntervalSince1970: TimeInterval(0))
    @State var locationOfTheTattoo: String = String()
    
    // issuingOfThePassport
    
    @State var issuingVetName: String = String()
    @State var issuingVetAddress: String = String()
    @State var issuingVetPostCode: String = String()
    @State var issuingVetCity: String = String()
    @State var issuingVetCountry: String = String()
    @State var issuingVetTelephoneNumber: String = String()
    @State var issuingVetRmailAddress: String = String()
    @State var issuingVetSPNumber: String = String()
    // - - - - - - - - - - - - - - - -
    @State var dateOfIssuing: Date = Date(timeIntervalSince1970: TimeInterval(0))
    
    // vaccinationAgainstRabies
    
    @State var vaccinatingVetName0: String = String()
    @State var vaccinatingVetAddress0: String  = String()
    @State var vaccinatingVetTelephoneNumber0: String = String()
    @State var vaccinatingVetSPNumber0: String = String()
    // - - - - - - - - - - - - - - - -
    @State var manufacturer0: String = String()
    @State var nameOfVaccine0: String = String()
    @State var batchNumber0: String = String()
    // - - - - - - - - - - - - - - - -
    @State var vaccinationDate0: Date = Date(timeIntervalSince1970: TimeInterval(0))
    @State var validFrom0: Date = Date(timeIntervalSince1970: TimeInterval(0))
    @State var validUntil0: Date = Date(timeIntervalSince1970: TimeInterval(0))
    // --------------------------------
    @State var vaccinatingVetName1: String = String()
    @State var vaccinatingVetAddress1: String = String()
    @State var vaccinatingVetTelephoneNumber1: String = String()
    @State var vaccinatingVetSPNumber1: String = String()
    // - - - - - - - - - - - - - - - -
    @State var manufacturer1: String = String()
    @State var nameOfVaccine1: String = String()
    @State var batchNumber1: String = String()
    // - - - - - - - - - - - - - - - -
    @State var vaccinationDate1: Date = Date(timeIntervalSince1970: TimeInterval(0))
    @State var validFrom1: Date = Date(timeIntervalSince1970: TimeInterval(0))
    @State var validUntil1: Date = Date(timeIntervalSince1970: TimeInterval(0))
    // --------------------------------
    
    
    // rabiesAntibodyTitrationTest
    
    @State var titratingVetName: String = String()
    @State var titratingVetAddress: String = String()
    @State var titratingVetTelephoneNumber: String = String()
    // - - - - - - - - - - - - - - - -
    @State var sampleCollectedOn: Date = Date(timeIntervalSince1970: TimeInterval(bitPattern: 0))
    @State var titratingDate: Date = Date(timeIntervalSince1970: TimeInterval(bitPattern: 0))
    
    // antiEchinococcusTreatment
    
    @State var treatingVetName0: String = String()
    @State var treatingVetaddress0: String = String()
    @State var treatingVettelephoneNumber0: String = String()
    @State var treatingVetSPNumber0: String = String()
    // - - - - - - - - - - - - - - - -
    @State var treatMnufacturer0: String = String()
    @State var treatProductName0: String = String()
    // - - - - - - - - - - - - - - - -
    @State var treatingDate0: Date = Date(timeIntervalSince1970: TimeInterval(bitPattern: 0))
    @State var treatingTime0: Date = Date(timeIntervalSince1970: TimeInterval(bitPattern: 0))
    // --------------------------------
    @State var treatingVetName1: String = String()
    @State var treatingVetaddress1: String = String()
    @State var treatingVettelephoneNumber1: String = String()
    @State var treatingVetSPNumber1: String = String()
    // - - - - - - - - - - - - - - - -
    @State var treatManufacturer1: String = String()
    @State var treatProductName1: String = String()
    // - - - - - - - - - - - - - - - -
    @State var treatingDate1: Date = Date(timeIntervalSince1970: TimeInterval(bitPattern: 0))
    @State var treatingTime1: Date = Date(timeIntervalSince1970: TimeInterval(bitPattern: 0))
    // --------------------------------
    @State var treatingVetName2: String = String()
    @State var treatingVetaddress2: String = String()
    @State var treatingVettelephoneNumber2: String = String()
    @State var treatingVetSPNumber2: String = String()
    // - - - - - - - - - - - - - - - -
    @State var treatManufacturer2: String = String()
    @State var treatProductName2: String = String()
    // - - - - - - - - - - - - - - - -
    @State var treatingDate2: Date = Date(timeIntervalSince1970: TimeInterval(bitPattern: 0))
    @State var treatingTime2: Date = Date(timeIntervalSince1970: TimeInterval(bitPattern: 0))
    // --------------------------------

    @State var size: CGSize = .zero
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // //////////////////////////////////////////////////////////////////// BODY

    var body: some View {
        ZStack {
            Form {
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MARK: TITLE
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                
                VStack(spacing: -14) {
                    Text("companion animal")
                        .foregroundColor(Color.secondary)
                        .font(.largeTitle)
                    Text("passport")
                        .foregroundColor(Color.primary)
                        .font(.largeTitle)
                }
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/ MARK: DETAILS OF OWNERSHIP
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                
                Group { // GROUP00
                    
                    Section {
                        Group { // GROUP01
                            Text("OWNER 1:")
                                .foregroundColor(Color.accentColor)
                                .font(.subheadline)
                                .padding()
                            TextField("Name", text: $ownerName0, prompt: Text("Name"))
                                .keyboardType(.namePhonePad)
                            TextField("Surname", text: $ownerSurname0, prompt: Text("Surname"))
                                .keyboardType(.namePhonePad)
                            TextField("Addres", text: $ownerAddres0, prompt: Text("Addres"))
                            TextField("Post-Code", text: $ownerPostCode0, prompt: Text("Post-Code"))
                            TextField("City", text: $ownerCity0, prompt: Text("City"))
                            TextField("Country", text: $ownerCountry0, prompt: Text("Country"))
                            TextField("Telephone number", text: $ownerTelephoneNumber0, prompt: Text("Telephone number"))
                                .keyboardType(.phonePad)
                        } // GROUP01
                        Group { // GROUP02
                            Text("OWNER 2:")
                                .foregroundColor(Color.accentColor)
                                .font(.subheadline)
                                .padding()
                            //
                            TextField("Name", text: $ownerName1, prompt: Text("Name"))
                                .keyboardType(.namePhonePad)
                            TextField("Surname", text: $ownerSurname1, prompt: Text("Surname"))
                                .keyboardType(.namePhonePad)
                            TextField("Addres", text: $ownerAddres1, prompt: Text("Adress"))
                            TextField("Post-Code", text: $ownerPostCode1, prompt: Text("Post-Code"))
                            TextField("City", text: $ownerCity1, prompt: Text("City"))
                            TextField("Country", text: $ownerCountry1, prompt: Text("Country"))
                            TextField("Telephone number", text: $ownerTelephoneNumber1, prompt: Text("Telephone number"))
                                .keyboardType(.phonePad)
                        } // GROUP02
                    } header: {
                        VStack(alignment: .leading) {
                            Text("DETAILS OF OWNERSHIP")
                                .foregroundColor(Color.secondary)
                                .font(.title)
                                .padding()
                            Text("The first name(s), surname and full address of the person to whom the passport is first issued should be entered in Part 1 of this page. The owner must sign in this section of the passport.")
                                .padding()
                            Text("The owner named in the passport must be aged over 16.")
                                .padding()
                        }
                    } footer: {
                        VStack(alignment: .leading) {
                            
                            Text("Change of owner/address")
                                .foregroundColor(Color.secondary)
                                .font(.headline)
                                .padding()
                            Text("If the owner of the animal reports a change of address to a veterinary practice, the details of the new address along with the owner’s name should be entered in the next available section and again have an owner signature.")
                                .padding()
                            Text("If there is a subsequent change of ownership, the client can enter the details in the next section and sign.")
                                .padding()
                            
                            Text("Joint ownership")
                                .foregroundColor(Color.secondary)
                                .font(.headline)
                                .padding()
                            Text("The EU Regulation is purposefully designed with one owner in mind and never makes reference to more than one owner. However, pet owners may authorise another person in writing to accompany the pet if they aren’t able to travel.")
                                .padding()
                            
                            Text("Authorised person")
                                .foregroundColor(Color.secondary)
                                .font(.headline)
                                .padding()
                            Text("The pet owner named in Section I may give written authorisation to another person to travel with their pet. This authorisation does not need to follow any particular format, but should contain the details of the owner, the details of the authorised person, and the pet details i.e. microchip number etc.")
                                .padding()
                            
                            Text("Non-permanent or correspondence addresses")
                                .foregroundColor(Color.secondary)
                                .font(.headline)
                                .padding()
                            Text("There is no requirement for an owner to have a permanent residential address in order to be issued with a pet passport. The passport can be issued with a correspondence address recorded in Section I.")
                                .padding()
                        }
                    }
                    
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // \/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\ MARK: DESCRIPTION OF ANIMAL
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    
                    Section {
                        Group { // GROUP03
                            if let picture {
                                
                                // ::::::::::::::::::::::::::
                                // IF ANY IMAGE EXISTS ::::::
                                // ::::::::::::::::::::::::::
                                
                                picture
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(15)
//                                    .padding(.horizontal)
//                                    .padding()
                                    .overlay(alignment: .bottomTrailing) {
                                        
                                        // <|><|><|><|><|><
                                        // PICKER |><|><|><
                                        // <|><|><|><|><|><
                                        
                                        PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
//                                            Image(systemName: "camera.circle.fill")
//                                                .symbolRenderingMode(.multicolor)
//                                                .font(.title)
//                                                .foregroundColor(.accentColor)
//                                                .padding(.top)
//                                                .padding(.top)
//                                                .padding(.top)
//                                                .padding(.top)
//                                                .padding(.trailing)
                                            Color.clear
                                        }
                                    }
                                
                            } else {
                                
                                // ::::::::::::::::::::::::::::::::::::
                                // IF CONTACT IMAGE EXISTS ::::::::::::
                                // ::::::::::::::::::::::::::::::::::::
                                
                                if let picture {
                                    picture
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(15)
//                                        .padding(.horizontal)
//                                        .padding()
                                        .overlay(alignment: .bottomTrailing) {
                                            
                                            // <|><|><|><|><|><|>
                                            // PICKER |><|><|><|>
                                            // <|><|><|><|><|><|>
                                            
                                            PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
//                                                Image(systemName: "camera")
//                                                    .symbolRenderingMode(.multicolor)
//                                                    .font(.title)
//                                                    .foregroundColor(.accentColor)
//                                                    .padding(.top)
//                                                    .padding(.top)
//                                                    .padding(.top)
//                                                    .padding(.top)
//                                                    .padding(.trailing)
                                                Color.clear
                                            }
                                        }
                                    
                                } else {
                                    
                                    // ::::::::::::::::::::::::::::::::
                                    // IF CONTACT IMAGE DOESN'T EXIST :
                                    // ::::::::::::::::::::::::::::::::
                                    
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .resizable()
                                        .foregroundColor(Color.secondary)
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(15)
                                        .padding(100)
//                                        .padding(.horizontal)
//                                        .padding()
                                        .overlay(alignment: .bottomTrailing) {
                                            
                                            // <|><|><|><|><|><|>
                                            // PICKER |><|><|><|>
                                            // <|><|><|><|><|><|>
                                            
                                            PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
//                                                Image(systemName: "camera")
//                                                    .symbolRenderingMode(.multicolor)
//                                                    .font(.title)
//                                                    .foregroundColor(.accentColor)
//                                                    .padding(.top)
//                                                    .padding(.top)
//                                                    .padding(.top)
//                                                    .padding(.top)
//                                                    .padding(.trailing)
                                                Color.clear
                                            }
                                        }
                                }
                            }
                        } // GROUP03
                        Group { // GROUP04
                            TextField("Name", text: $name, prompt: Text("Name"))
                            
                            Picker("Species:", selection: $species) {
                                Text("Cat").tag(Species.cat)
                                Text("Dog").tag(Species.dog)
                            }
                            switch species {
                            case .cat:
                                Picker("Breed:", selection: $breed) {
                                    ForEach(Array(breedEngine.catCorrelate().values), id: \.self) { value in
                                        Text(String(value)).tag(value)
                                    }
                                }
                            case .dog:
                                Picker("Breed:", selection: $breed) {
                                    ForEach(Array(breedEngine.dogCorrelate().values), id: \.self) { value in
                                        Text(String(value)).tag(value)
                                    }
                                }
                            }
                            Picker("Sex:", selection: $sex) {
                                Text("Male").tag(Sex.male)
                                Text("Female").tag(Sex.female)
                            }
                            DatePicker("Date of Birth:", selection: $dateOfBirth, displayedComponents: .date)
                            ColorPicker("Colour:", selection: $colour, supportsOpacity: false)
                            TextField("Any notable or discernable features or characteristics", text: $notableOrDiscernableFeaturesOrCharacteristics, prompt: Text("Any notable or discernable features or characteristics"), axis: .vertical)
                        } // GROUP05
                    } header: {
                        VStack(alignment: .leading) {
                            Text("DESCRIPTION OF ANIMAL")
                                .foregroundColor(Color.secondary)
                                .font(.title)
                                .padding()
                            
                            Text("Insertion of a photograph of the animal is optional, and at the owner’s expense. The owner is responsible for affixing the photograph to the passport. The borders of the photograph must remain within the marked area and not obscure any other part of this page.")
                                .padding()
                            Text("Parts 1-7 can be completed by practice support staff or a veterinarian.")
                                .padding()
                            Text("The entry for species must be either dog, cat or ferret.")
                                .padding()
                            Text("The date of birth entry may contain the animal’s full date of birth, month and year of birth, or just year of birth, as stated by the owner. If the date of birth is not known, an approximate date may be entered.")
                                .padding()
                        }
                        
                    } footer: {
                        
                    }
                    
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // \/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MARK: MARKING OF ANIMAL
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    
                    Section(content: {
                        Group { // GROUP06
                            TextField("Transponder alphanumeric code", text: $transponderAlphanumericCode, prompt: Text("Transponder alphanumeric code"))
                                .monospaced()
                                .keyboardType(.namePhonePad)
                            DatePicker("Date of application or reading of the transponder", selection: $dateOfApplicationOrReadingOfTheTransponder, displayedComponents: .date)
                            TextField("Location of the transponder", text: $locationOfTheTransponder, prompt: Text("Location of the transponder"))
                            TextField("Tattoo alphanumeric code", text: $tattooAlphanumericCode, prompt: Text("Tattoo alphanumeric code"))
                                .monospaced()
                                .keyboardType(.namePhonePad)
                            DatePicker("Date of application or reading of the tattoo", selection: $dateOfApplicationOrReadingOfTheTattoo, displayedComponents: .date)
                            TextField("Location of the tattoo", text: $locationOfTheTattoo, prompt: Text("Location of the tattoo"))
                        } // GROUP06
                    }, header: {
                        Group { // GROUP07
                            VStack(alignment: .leading) {
                                Text("MARKING OF ANIMAL")
                                    .foregroundColor(Color.secondary)
                                    .font(.title)
                                    .padding()
                                Text("Can be completed by practice support staff or a veterinarian.")
                                    .padding()
                                Text("The microchip/transponder must be scanned and read before any entry is made in this section.")
                                    .padding()
                            }
                        } // GROUP 07
                    }, footer: {
                        Group { // GROU08
                            VStack(alignment: .leading) {
                                
                                Text("Date of application or reading of the transponder")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("The date of application or reading must not postdate any compulsory vaccination or treatment. The entry should be in the format dd/mm/yyyy. This section must not be left blank. Do not enter ‘not known’.")
                                    .padding()
                                Text("- \tIf a microchip has been implanted and can be read, but the exact date of microchipping is not known, enter the date of the reading. The appropriate deletion should be made to show which date is being declared.")
                                    .padding()
                                Text("- \tWhere certifying this information on the basis of evidence provided by another veterinary surgeon, ensure that this date does not postdate any compulsory vaccination or treatment.")
                                    .padding()
                                
                                Text("Location of transponder")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("Insert location of microchip as indicated by passing the reader over the animal.")
                                    .padding()
                                
                                Text("Tattooing")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("Tattoos are not acceptable as a means of identification, unless administered before 3 July 2011. If an inspection of the animal reveals a clearly legible tattoo number, this can be entered in this section.")
                                    .padding()
                                
                                Text("Lamination")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("Once this section is completed, the page must be laminated using the laminate sheet provided. If a mistake is identified after the lamination is sealed, a new passport will need to be issued.")
                                    .padding()
                            }
                            
                        } // GROUP08
                    })
                    
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // \/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\ MARK: ISSUING OF THE PASSPORT
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    
                    Section(content: {
                        Group { // GROUP09
                            TextField("Name of the authorised veterinarian", text: $issuingVetName, prompt: Text("Name of the authorised veterinarian"))
                                .keyboardType(.namePhonePad)
                            TextField("Addres", text: $issuingVetAddress, prompt: Text("Adress"))
                            TextField("Post-Code", text: $issuingVetPostCode, prompt: Text("Post-Code"))
                            TextField("City", text: $issuingVetCity, prompt: Text("City"))
                            TextField("Country", text: $issuingVetCountry, prompt: Text("Country"))
                            TextField("Telephone number", text: $issuingVetTelephoneNumber, prompt: Text("Name"))
                                .keyboardType(.phonePad)
                            TextField("E-mail address", text: $issuingVetRmailAddress, prompt: Text("E-mail address"))
                                .keyboardType(.emailAddress)
                            DatePicker("Date of Issuing:", selection: $dateOfIssuing, displayedComponents: .date)
                            //
                        } // GROUP09
                    }, header: {
                        Group { //GROUP10
                            VStack(alignment: .leading) {
                                
                                Text("ISSUING OF THE PASSPORT")
                                    .foregroundColor(Color.secondary)
                                    .font(.title)
                                    .padding()
                                Text("The passport is issued when Sections I, II, III and IV are completed.")
                                    .padding()
                                Text("This page must be completed by an OV and the OV stamp used.")
                                    .padding()
                                Text("The address and telephone number should be that of the practice where the passport is issued.")
                                    .padding()
                                Text("OVs should enter their practice email address in this section where possible, although locum OVs may enter a private email address.")
                                    .padding()
                            }
                        } // GROUP10
                    }, footer: {
                        Group { // GROUP11
                            
                        } // GROUP11
                    })
                } // GROUP00
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/\//\/\/\/\/\/\/\/\/\/\/\/ MARK: VACCINATION AGAINST RABIES
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                
                Section(content: {
                    Group { // GROUP12
                        Text("VACCINATION 1")
                            .foregroundColor(Color.accentColor)
                            .font(.subheadline)
                            .padding()
                        Group { // GROUP13
                            Text("AUTHORIZED VETERINARIAN")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Name of the authorised veterinarian", text: $vaccinatingVetName0, prompt: Text("Name of the authorised veterinarian"))
                                .keyboardType(.namePhonePad)
                            TextField("Address", text: $vaccinatingVetAddress0, prompt: Text("Address"))
                            TextField("Telephone number", text: $vaccinatingVetTelephoneNumber0, prompt: Text("Telephone number"))
                                .keyboardType(.phonePad)
                            TextField("SP number", text: $vaccinatingVetSPNumber0, prompt: Text("SP number"))
                        } // GROUP13
                    } // GROUP12
                    Group { // GROUP14
                        Group { // GROUP15
                            Text("MANUFACTURER AND NAME OF VACCINE")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Manufacturer", text: $manufacturer0, prompt: Text("Manufacturer"))
                            TextField("Name of Vaccine", text: $nameOfVaccine0, prompt: Text("Name of Vaccine"))
                        } // GROUP15
                        Group { // GROUP16
                            Text("BATCH NUMBER")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Batch Number", text: $batchNumber0, prompt: Text("Batch Number"))
                        } // GROUP17
                        Group { // GROUP18
                            Text("VACCINATION DATA AND VALID FROM/UNTIL")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            DatePicker("Vaccination Date", selection: $vaccinationDate0, displayedComponents: .date)
                            DatePicker("Valid from", selection: $validFrom0, displayedComponents: .date)
                            DatePicker("Valid Until", selection: $validUntil0, displayedComponents: .date)
                        }
                        Text("VACCINATION 2")
                            .foregroundColor(Color.accentColor)
                            .font(.subheadline)
                            .padding()
                        Group { // GROUP19
                            Text("AUTHORIZED VETERINARIAN")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Name of the authorised veterinarian", text: $vaccinatingVetName1, prompt: Text("Name of the authorised veterinarian"))
                                .keyboardType(.namePhonePad)
                            TextField("Address", text: $vaccinatingVetAddress1, prompt: Text("Address"))
                            TextField("Telephone number", text: $vaccinatingVetTelephoneNumber1, prompt: Text("Telephone number"))
                                .keyboardType(.phonePad)
                            TextField("SP number", text: $vaccinatingVetSPNumber1, prompt: Text("SP number"))
                        } // GROUP19
                    } // GROUP14
                    Group { // GROUP20
                        Group { // GROUP21
                            Text("MANUFACTURER AND NAME OF VACCINE")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Manufacturer", text: $manufacturer1, prompt: Text("Manufacturer"))
                            TextField("Name of Vaccine", text: $nameOfVaccine1, prompt: Text("Name of Vaccine"))
                        } // GROUP21
                        Group { // GROUP22
                            Text("BATCH NUMBER")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Batch Number", text: $batchNumber1, prompt: Text("Batch Number"))
                        } // GROUP22
                        Group { // GROUP23
                            Text("VACCINATION DATA AND VALID FROM/UNTIL")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            DatePicker("Vaccination Date", selection: $vaccinationDate1, displayedComponents: .date)
                            DatePicker("Valid from", selection: $validFrom1, displayedComponents: .date)
                            DatePicker("Valid Until", selection: $validUntil1, displayedComponents: .date)
                        } // GROUP23
                    } // GROUP20
                }, header: {
                    Group { // GROUP24
                        VStack(alignment: .leading) {
                            Text("VACCINATION AGAINST RABIES")
                                .foregroundColor(Color.secondary)
                                .font(.title)
                                .padding()
                            Text("This page must be completed by an OV.")
                                .padding()
                            Text("Before any entry is made in any part of this section, the animal’s microchip number must be read and verified against the entry in section III of the passport. Details of the current rabies vaccination must be recorded in the passport.")
                                .padding()
                            Text("An approved inactivated rabies vaccine or recombinant vaccine must be used and administered in accordance with the recommendations of the manufacturer.")
                                .padding()
                        }
                    } // GROUP24
                }, footer: {
                    Group { // GROUP25
                        VStack(alignment: .leading) {
                            Group { // GROUP26
                                Text("Manufacturer, Name of Vaccine and Batch number")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("Where possible, the sticker supplied with each dose of vaccine should be inserted in this box. If the sticker does not provide all the required information, please enter any missing information immediately below or adjacent to the sticker. Where a sticker is not available, the required information may be entered by hand. There are additional lamination sheets included in the passport which are ‘kiss-cut’, and individual sections must be removed and placed over the vaccination sticker for each entry.")
                                    .padding()
                            } // GROUP26
                            Group { // GROUP27
                                Text("Vaccination Date/Valid From/Valid Until")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("If an animal is already vaccinated, the date of vaccination can be entered on the basis of practice records or suitable supporting evidence, which must show the animal’s microchip number. A ‘valid from’ date should be entered for the first recorded vaccine. This date is the 21st day after the first vaccination, where the day of vaccination is day 0. Booster vaccinations given within the validity period of the previous vaccine do not need an entry in the ‘valid from’ field.")
                                    .padding()
                                Text("The ‘valid until’ date is the date when the next booster is due, and should where possible be based on the information in the manufacturer’s datasheet. If this is not available, valid until dates can be entered on the basis of practice records or suitable supporting evidence, which must show the animal’s microchip number. The valid until date will be one to three calendar years after the vaccination date, depending on the validity period of the vaccine used e.g. vaccination date 01/01/2016, valid until 01/01/2019.")
                                    .padding()
                            } // GROUP27
                            Group { // GROUP28
                                Text("Authorised Veterinarian")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("In new style pet passports, the OV stamp must not be used in this section. The OV should sign in this section and must enter their name, address, telephone number and SP number. A stamp with these details can be used.")
                                    .padding()
                            } // GROUP28
                            Group { // GROUP29
                                Text("Old style pet passports")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("Old style pet passports (issued prior to December 2014) are valid for travel until all of the treatment spaces are filled. Rabies vaccinations can be added to old style pet passports, even if there has been a break in vaccine cover.")
                                    .padding()
                                Text("As old style pet passports do not have a box for the ‘valid from’ date, this information does not need to be included. The vaccine sticker does not need to be laminated.")
                                    .padding()
                            } // GROUP29
                            Group { // GROUP30
                                Text("Booster vaccinations")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("After a pet has been vaccinated, it will need regular booster vaccinations in accordance with the manufacturer’s datasheet. These must be given by the ‘Valid until’ date. If this date is missed the animal will not meet the conditions of the scheme and will have to be re-vaccinated. The animal will be eligible to travel 21 days after the vaccination.")
                                    .padding()
                                Text("If a booster has been missed since a blood test was carried out, the blood test will no longer be valid and the pet must be revaccinated and a further blood test performed at least 30 days after vaccination (if returning from an unlisted country).")
                                    .padding()
                            } // GROUP30
                            Group { // GROUP31
                                Text("Administering rabies vaccines with other medications")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("In order to be able to certify a vaccination for pet travel, it must comply with the datasheet. If the datasheet indicates that the vaccine would not be effective when mixed with other drugs/vaccines or might otherwise not be protective (e.g. in immunocompromised animals), OVs must seek advice from the vaccine manufacturer. OVs should only certify a rabies vaccination if the manufacturer can confirm that the animal will be protected in the proposed circumstances.")
                                    .padding()
                            } // GROUP31
                        }
                    } // GROUP25
                })
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/\//\/\/\/\/\/\/\/\/\/ MARK: RABIES ANTIBODY TITRATION TEST
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                
                Section(content: {
                    Group {
                        DatePicker("Sample collected on:", selection: $sampleCollectedOn, displayedComponents: .date)
                        TextField("Name of the authorised veterinarian", text: $titratingVetName, prompt: Text("Name of the authorised veterinarian"))
                            .keyboardType(.namePhonePad)
                        TextField("Address", text: $titratingVetAddress, prompt: Text("Address"))
                        TextField("Telephone number", text: $titratingVetTelephoneNumber, prompt: Text("Telephone number"))
                            .keyboardType(.phonePad)
                        DatePicker("Date", selection: $titratingDate, displayedComponents: .date)
                    } // GROUP
                }, header: {
                    Group {
                        VStack(alignment: .leading) {
                            
                            Text("RABIES ANTIBODY TITRATION TEST")
                                .foregroundColor(Color.secondary)
                                .font(.title)
                                .padding()
                            Text("This page must be completed by an OV and the OV stamp used.")
                                .padding()
                            Text("Before any entry is made in this section, the animal’s microchip number must be read and verified against the entry in section III of the passport.")
                                .padding()
                            Text("A satisfactory result must indicate a titre level equal to or greater than 0.5 IU/ml.")
                                .padding()
                            Text("When a satisfactory test result is received from the laboratory, please complete this section of the passport. The date when the blood sample for the rabies serology was drawn must be entered.")
                                .padding()
                        }
                    } // GROUP
                }, footer: {
                    Group {
                        Group {
                            
                            Text("Approved laboratories")
                                .foregroundColor(Color.secondary)
                                .font(.headline)
                                .padding()
                            Text("The blood sample must be sent to a European Union (EU) approved laboratory for testing. Before taking the sample, contact the laboratory to obtain the appropriate sample submission form and seek advice on the correct labelling and means of packaging and transportation of the sample.")
                                .padding()
                        }
                        Group {
                            
                            Text("Missed booster vaccinations")
                                .foregroundColor(Color.secondary)
                                .font(.headline)
                                .padding()
                            Text("If a booster has been missed since a blood test was carried out, the pet should be re-prepared accordingly. An entry in section XII must be made to indicate that the titre results are no longer valid for EU entry from unlisted Third Countries. The original blood test result in this section must be crossed out, and a new entry made under ‘in case of a further test'.")
                                .padding()
                        }
                        
                    } // GROUP
                })
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/ MARK: ANTI-ECHINOCCOCUS TEST
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                
                Section(content: {
                    Group {
                        Text("TEST 1")
                            .foregroundColor(Color.accentColor)
                            .font(.subheadline)
                            .padding()
                        Group {
                            Text("MANUFACTURER AND NAME OF PRODUCT")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Manufacturer", text: $treatMnufacturer0, prompt: Text("Manufacturer"))
                            TextField("Product name", text: $treatProductName0, prompt: Text("Product name"))
                        }
                        Group {
                            Text("DATE AND TIME")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            DatePicker("Date", selection: $treatingDate0, displayedComponents: .date)
                            DatePicker("Time", selection: $treatingTime0, displayedComponents: .hourAndMinute)
                        }
                        Group {
                            Text("VETERINARIAN")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Name", text: $treatingVetName0, prompt: Text("Name"))
                                .keyboardType(.namePhonePad)
                            TextField("Address", text: $treatingVetaddress0, prompt: Text("Address"))
                            TextField("Telephone number", text: $treatingVettelephoneNumber0, prompt: Text("Telephone number"))
                                .keyboardType(.phonePad)
                            TextField("SP number", text: $treatingVettelephoneNumber0, prompt: Text("SP number"))
                        }
                    }
                    Group {
                        Text("TEST 2")
                            .foregroundColor(Color.accentColor)
                            .font(.subheadline)
                            .padding()
                        Group {
                            Text("MANUFACTURER AND NAME OF PRODUCT")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Manufacturer", text: $treatManufacturer1, prompt: Text("Manufacturer"))
                            TextField("Product name", text: $treatProductName1, prompt: Text("Product name"))
                        }
                        Group {
                            Text("DATE AND TIME")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            DatePicker("Date", selection: $treatingDate1, displayedComponents: .date)
                            DatePicker("Time", selection: $treatingTime1, displayedComponents: .hourAndMinute)
                        }
                        Group {
                            Text("VETERINARIAN")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Name", text: $treatingVetName1, prompt: Text("Name"))
                                .keyboardType(.namePhonePad)
                            TextField("Address", text: $treatingVetaddress1, prompt: Text("Address"))
                            TextField("Telephone number", text: $treatingVettelephoneNumber1, prompt: Text("Telephone number"))
                                .keyboardType(.phonePad)
                            TextField("SP number", text: $treatingVettelephoneNumber1, prompt: Text("SP number"))
                        }
                    }
                    Group {
                        Text("TEST 3")
                            .foregroundColor(Color.accentColor)
                            .font(.subheadline)
                            .padding()
                        Group {
                            Text("MANUFACTURER AND NAME OF PRODUCT")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Manufacturer", text: $treatManufacturer1, prompt: Text("Manufacturer"))
                            TextField("Product name", text: $treatProductName1, prompt: Text("Product name"))
                        }
                        Group {
                            Text("DATE AND TIME")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            DatePicker("Date", selection: $treatingDate1, displayedComponents: .date)
                            DatePicker("Time", selection: $treatingTime1, displayedComponents: .hourAndMinute)
                        }
                        Group {
                            Text("VETERINARIAN")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding()
                            TextField("Name", text: $treatingVetName1, prompt: Text("Name"))
                                .keyboardType(.namePhonePad)
                            TextField("Address", text: $treatingVetaddress1, prompt: Text("Address"))
                            TextField("Telephone number", text: $treatingVettelephoneNumber1, prompt: Text("Telephone number"))
                                .keyboardType(.phonePad)
                            TextField("SP number", text: $treatingVettelephoneNumber1, prompt: Text("SP number"))
                        }
                    }
                }, header: {
                    Group {
                        VStack(alignment: .leading) {
                            Text("ANTI-ECHINOCOCCUS TREATMENT")
                                .foregroundColor(Color.secondary)
                                .font(.title)
                                .padding()
                            Text("Before any entry is made in this section, the animal’s microchip number must be read and verified against the entry in section III of the passport.")
                                .padding()
                            Text("Before entering or re-entering the UK, a dog must be treated by a qualified veterinarian against the tapeworm Echinococcus multilocularis. The treatment must be carried out not less than 24 hours and not more than 120 hours before the pet is landed in the UK (unless travelling directly from Finland, Ireland, Malta or Norway).")
                                .padding()
                            Text("Dogs leaving the UK on short trips will need to have this treatment administered prior to departure from the UK. This is so the timing requirement described above can be satisfied.")
                                .padding()
                        }
                    } // GROUP
                }, footer: {
                    Group {
                        VStack(alignment: .leading) {
                            Group {
                                Text("Treatment")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("The tapeworm treatment must contain praziquantel, or be a treatment proven to be effective against Echinoccocus multilocularis. It must be administered in accordance with the manufacturer’s instructions.")
                                    .padding()
                            }
                            Group {
                                Text("Completion")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                                    .padding()
                                Text("The product details should be entered in the box marked ‘Manufacturer and name of product’. The date and time of treatment should be entered in the boxes marked ‘Date/Time’. Please enter the date in dd/mm/yyyy format. For the time, enter using 24- hour clock, e.g. 15:30.")
                                    .padding()
                                Text("The product details should be entered in the box marked ‘Manufacturer and name of product’. The date and time of treatment should be entered in the boxes marked ‘Date/Time’. Please enter the date in dd/mm/yyyy format. For the time, enter using 24- hour clock, e.g. 15:30.")
                                    .padding()
                                Text("If the veterinarian administering treatment is an OV, their stamp must be entered in the box marked ‘veterinarian’. If the veterinarian administering treatment is not an OV, the practice stamp must be entered in the box. In both cases, the administering veterinarian must also sign in the box.")
                                    .padding()
                            }
                        }
                    } // GROUP
                })
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MARK: NOTES
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                
                Section {
                    TextField("Notes", text: $notes, prompt: Text("Notes"), axis: .vertical)
                } header: {
                    Text("NOTES")
                } footer: {
                    
                }
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MARK: UPDATE BUTTON
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                
                
                Button(action: {
                    
                    var patient: Patient = Patient(
                        
                        id: UUID(),
                        
                        passport: Patient.Passport(
                            
                            detailsOfOwnership: DetailsOfOwnership(owners: [
                                DetailsOfOwnership.Owner(
                                    id: UUID(),
                                    name: ownerName0.isEmpty ? nil : ownerName0,
                                    surname: ownerSurname0.isEmpty ? nil : ownerSurname0,
                                    addres: ownerAddres0.isEmpty ? nil : ownerAddres0,
                                    postCode: ownerPostCode0.isEmpty ? nil : ownerPostCode0,
                                    city: ownerCity0.isEmpty ? nil : ownerCity0,
                                    country: ownerCountry0.isEmpty ? nil : ownerCountry0,
                                    telephoneNumber: ownerTelephoneNumber0.isEmpty ? nil : ownerTelephoneNumber0
                                ),
                                
                                // --------------------------------------
                                
                                DetailsOfOwnership.Owner(
                                    id: UUID(),
                                    name: ownerName1.isEmpty ? nil : ownerName1,
                                    surname: ownerSurname1.isEmpty ? nil : ownerSurname1,
                                    addres: ownerAddres1.isEmpty ? nil : ownerAddres1,
                                    postCode: ownerPostCode1.isEmpty ? nil : ownerPostCode1,
                                    city: ownerCity1.isEmpty ? nil : ownerCity1,
                                    country: ownerCountry1.isEmpty ? nil : ownerCountry1,
                                    telephoneNumber: ownerTelephoneNumber1.isEmpty ? nil : ownerTelephoneNumber1
                                )
                            ]),
                            
                            // ====================================================
                            
                            descriptionOfAnimal: DescriptionOfAnimal(
                                pictureId: nil,
                                name: name.isEmpty ? nil : name,
                                species: species,
                                breed: breed.isEmpty ? nil : breed,
                                sex: sex,
                                dateOfBirth: dateOfBirth,
                                colour: colour,
                                notableOrDiscernableFeaturesOrCharacteristics: notableOrDiscernableFeaturesOrCharacteristics.isEmpty ? nil : notableOrDiscernableFeaturesOrCharacteristics
                            ),
                            
                            // ====================================================
                            
                            markingOfAnimal: MarkingOfAnimal(
                                transponderAlphanumericCode: transponderAlphanumericCode.isEmpty ? nil : transponderAlphanumericCode,
                                dateOfApplicationOrReadingOfTheTransponder: dateOfApplicationOrReadingOfTheTransponder,
                                locationOfTheTransponder: locationOfTheTransponder.isEmpty ? nil : locationOfTheTransponder,
                                tattooAlphanumericCode: tattooAlphanumericCode.isEmpty ? nil : tattooAlphanumericCode,
                                dateOfApplicationOrReadingOfTheTattoo: dateOfApplicationOrReadingOfTheTattoo,
                                locationOfTheTattoo: locationOfTheTattoo.isEmpty ? nil : locationOfTheTattoo
                            ),
                            
                            // ====================================================
                            
                            issuingOfThePassport: IssuingOfThePassport(
                                
                                authorisedVeterinarian: IssuingOfThePassport.AuthorisedVeterinarian(
                                    name: issuingVetName.isEmpty ? nil : issuingVetName,
                                    address: issuingVetAddress.isEmpty ? nil : issuingVetAddress,
                                    postCode: issuingVetPostCode.isEmpty ? nil : issuingVetPostCode,
                                    city: issuingVetCity.isEmpty ? nil : issuingVetCity,
                                    country: issuingVetCountry.isEmpty ? nil : issuingVetCountry,
                                    telephoneNumber: issuingVetTelephoneNumber.isEmpty ? nil : issuingVetTelephoneNumber,
                                    emailAddress: issuingVetRmailAddress.isEmpty ? nil : issuingVetRmailAddress,
                                    spNumber: issuingVetSPNumber.isEmpty ? nil : issuingVetSPNumber
                                ),
                                
                                dateOfIssuing: dateOfIssuing
                            ),
                            
                            // ====================================================
                            
                            vaccinationAgainstRabies: VaccinationAgainstRabies(
                                vaccinations: [
                                    
                                    VaccinationAgainstRabies.Vaccination(
                                        
                                        id: UUID(),
                                        
                                        rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine (
                                            id: UUID(),
                                            manufacturer: manufacturer0.isEmpty ? nil : manufacturer0,
                                            nameOfVaccine: nameOfVaccine0.isEmpty ? nil : nameOfVaccine0,
                                            batchNumber: batchNumber0.isEmpty ? nil : batchNumber0
                                        ),
                                        
                                        vaccinationDate: vaccinationDate0,
                                        validFrom: validFrom0,
                                        validUntil: validUntil0,
                                        
                                        authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian(
                                            name: vaccinatingVetName0.isEmpty ? nil : vaccinatingVetName0,
                                            address: vaccinatingVetAddress0.isEmpty ? nil : vaccinatingVetAddress0,
                                            telephoneNumber: vaccinatingVetTelephoneNumber0.isEmpty ? nil : vaccinatingVetTelephoneNumber0,
                                            spNumber: vaccinatingVetSPNumber0.isEmpty ? nil : vaccinatingVetSPNumber0
                                        )
                                    ),
                                    
                                    // -------------------------------------------------------------------------------
                                    
                                    VaccinationAgainstRabies.Vaccination(
                                        
                                        id: UUID(),
                                        
                                        rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine (
                                            id: UUID(),
                                            manufacturer: manufacturer1.isEmpty ? nil : manufacturer1,
                                            nameOfVaccine: nameOfVaccine1.isEmpty ? nil : nameOfVaccine1,
                                            batchNumber: batchNumber1.isEmpty ? nil : batchNumber1
                                        ),
                                        
                                        vaccinationDate: vaccinationDate1,
                                        validFrom: validFrom1,
                                        validUntil: validUntil1,
                                        
                                        authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian(
                                            name: vaccinatingVetName1.isEmpty ? nil : vaccinatingVetName1,
                                            address: vaccinatingVetAddress1.isEmpty ? nil : vaccinatingVetAddress1,
                                            telephoneNumber: vaccinatingVetTelephoneNumber1.isEmpty ? nil : vaccinatingVetTelephoneNumber1,
                                            spNumber: vaccinatingVetSPNumber1.isEmpty ? nil : vaccinatingVetSPNumber1
                                        )
                                    )
                                ]
                            ),
                            
                            // ====================================================
                            
                            rabiesAntibodyTitrationTest: RabiesAntibodyTitrationTest(
                                
                                sampleCollectedOn: sampleCollectedOn,
                                
                                authorisedVeteriarian: RabiesAntibodyTitrationTest.AuthorisedVeterinarian(
                                    name: titratingVetName.isEmpty ? nil : titratingVetName,
                                    address: titratingVetAddress.isEmpty ? nil : titratingVetAddress,
                                    telephoneNumber: titratingVetTelephoneNumber.isEmpty ? nil : titratingVetTelephoneNumber
                                ),
                                
                                date: titratingDate
                            ),
                            
                            // ====================================================
                            
                            antiEchinococcusTreatment: AntiEchinococcusTreatment(
                                treatments: [
                                    
                                    AntiEchinococcusTreatment.Treatment(
                                        id: UUID(),
                                        
                                        product: AntiEchinococcusTreatment.Treatment.Product(
                                            manufacturer: treatMnufacturer0.isEmpty ? nil : treatMnufacturer0,
                                            productName: treatProductName0.isEmpty ? nil : treatProductName0
                                        ),
                                        
                                        date: treatingDate0,
                                        time: treatingTime0,
                                        
                                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                                            name: treatingVetName0.isEmpty ? nil : treatingVetName0,
                                            address: treatingVetaddress0.isEmpty ? nil : treatingVetaddress0,
                                            telephoneNumber: treatingVettelephoneNumber0.isEmpty ? nil : treatingVettelephoneNumber0,
                                            spNumber: treatingVetSPNumber0.isEmpty ? nil : treatingVetSPNumber0
                                        )
                                    ),
                                    
                                    // --------------------------------------------
                                    
                                    AntiEchinococcusTreatment.Treatment(
                                        id: UUID(),
                                        
                                        product: AntiEchinococcusTreatment.Treatment.Product(
                                            manufacturer: treatManufacturer1.isEmpty ? nil : treatManufacturer1,
                                            productName: treatProductName1.isEmpty ? nil : treatProductName1
                                        ),
                                        
                                        date: treatingDate2,
                                        time: treatingTime2,
                                        
                                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                                            name: treatingVetName1.isEmpty ? nil : treatingVetName1,
                                            address: treatingVetaddress1.isEmpty ? nil : treatingVetaddress1,
                                            telephoneNumber: treatingVettelephoneNumber1.isEmpty ? nil : treatingVettelephoneNumber1,
                                            spNumber: treatingVetSPNumber1.isEmpty ? nil : treatingVetSPNumber1
                                        )
                                    ),
                                    
                                    // --------------------------------------------
                                    
                                    AntiEchinococcusTreatment.Treatment(
                                        id: UUID(),
                                        
                                        product: AntiEchinococcusTreatment.Treatment.Product(
                                            
                                            manufacturer: treatManufacturer2.isEmpty ? nil : treatManufacturer2,
                                            productName: treatProductName2.isEmpty ? nil : treatProductName2
                                        ),
                                        
                                        date: treatingDate2,
                                        time: treatingTime2,
                                        
                                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                                            name: treatingVetName2.isEmpty ? nil : treatingVetName2,
                                            address: treatingVetaddress2.isEmpty ? nil : treatingVetaddress2,
                                            telephoneNumber: treatingVettelephoneNumber2.isEmpty ? nil : treatingVettelephoneNumber2,
                                            spNumber: treatingVetSPNumber2.isEmpty ? nil : treatingVetSPNumber2
                                        )
                                    )
                                ]
                            )
                            
                            // ====================================================
                        ),
                        
                        guardianId: nil,
                        notes: notes.isEmpty ? nil : notes
                    )
                    
                    do {
                        try patientGig.create(patient: patient)
                        if let uiImage {
                            try patientGig.set(uiImage: uiImage, toPatient: &patient)
                        }
                        goCreate.toggle()
                    } catch {
                        print(error.localizedDescription)
                        // VJotError ////////////////////
                        vjotError = VJotError.error(error)
                        vjotErrorThrown.toggle()
                    }
                    
                }, label: {
                    HStack {
                        Text("CREATE")
                        Image(systemName: "plus.circle.fill")
                    }
                })
                .buttonStyle(.borderedProminent)
                .padding()
                
                
                
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: IMAGE
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)
                
                .onChange(of: photosPickerItem) { newValue in
                    Task {
                        let data: Data? = try? await photosPickerItem?.loadTransferable(type: Data.self)
                        if let data = data {
                            if let image = UIImage(data: data) {
                                uiImage = image
                                if let uiImage {
                                    picture = Image(uiImage: uiImage)
                                }
                                return
                            }
                        }
                    }
                }
                
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
            } // FORM
            
            // {-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}
            // {-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-} MARK: DISMISS BUTTON
            // {-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}
            
            VStack {
                HStack {
                    
                    // {-}{-}{-}{-}{-}{
                    // HSPACER }{-}{-}{
                    // {-}{-}{-}{-}{-}{
                    
                    Spacer()
                    
                    // {-}{-}{-}{-}{-}{
                    // BUTTON -}{-}{-}{
                    // {-}{-}{-}{-}{-}{
                    
                    Button {
                        goCreate.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .padding()
                    }
                }
                
                // {-}{-}{-}{
                // VSPACER }{
                // {-}{-}{-}{
                
                Spacer()
            }
        }  // ZSTACK
    }
}


// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct PatientAdmissionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientCreateView()
//    }
//}
