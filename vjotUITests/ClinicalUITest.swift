//
//  clinicUITest.swift
//  vjotUITests
//
//  Created by Nikolaos Saridakis on 29/4/23.
//

import XCTest

final class ClinicalUITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(en)"]
        app.launchArguments += ["-AppleLocale", "en-US"]
        app.launch()
        app.buttons["WIPE"]/*@START_MENU_TOKEN@*/.press(forDuration: 0.5);/*[[".tap()",".press(forDuration: 0.5);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["BOOTSTRAP"].tap()
        sleep(60)
        app.tabBars["Tab Bar"].buttons["clinic"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["vets"]/*[[".cells.buttons[\"vets\"]",".buttons[\"vets\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["Swipe right to activate clinical session"].tap()
        
        let ttgc7swiftui32navigationstackhostingNavigationBar = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]
        let onboardButton = ttgc7swiftui32navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["ONBOARD"]/*[[".otherElements[\"ONBOARD\"].buttons[\"ONBOARD\"]",".buttons[\"ONBOARD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        onboardButton.tap()
        
        let closeButton = app.buttons["Close"]
        closeButton.tap()
        
        let editButton = ttgc7swiftui32navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Edit"]/*[[".otherElements[\"Edit\"].buttons[\"Edit\"]",".buttons[\"Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        editButton.tap()
        
        let doneButton = ttgc7swiftui32navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".otherElements[\"Done\"].buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Eleftheria Saridaki"]/*[[".cells.buttons[\"Eleftheria Saridaki\"]",".buttons[\"Eleftheria Saridaki\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["name:"].tap()
        elementsQuery.staticTexts["id:"].tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"name:").element.swipeUp()
        elementsQuery.staticTexts["Address:"].tap()
        elementsQuery.staticTexts["Post-code:"].tap()
        elementsQuery.staticTexts["City:"].tap()
        elementsQuery.staticTexts["Country:"].tap()
        elementsQuery.staticTexts["Telephone number:"].tap()
        elementsQuery.staticTexts["Email address:"].tap()
        editButton.tap()
        closeButton.tap()
        
        let backButton = ttgc7swiftui32navigationstackhostingNavigationBar.buttons["Back"]
        backButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Michalis Saridakis"]/*[[".cells.buttons[\"Michalis Saridakis\"]",".buttons[\"Michalis Saridakis\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Martha Saridaki"]/*[[".cells.buttons[\"Martha Saridaki\"]",".buttons[\"Martha Saridaki\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Nikos Saridakis"]/*[[".cells.buttons[\"Nikos Saridakis\"]",".buttons[\"Nikos Saridakis\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        backButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["cases"]/*[[".cells.buttons[\"cases\"]",".buttons[\"cases\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["Swipe right to select current incident"].tap()
        
        let calendarButton = app.buttons["Calendar"]
        calendarButton.tap()
        calendarButton.tap()
        
        let stethoscopeButton = app.buttons["Stethoscope"]
        stethoscopeButton.tap()
        stethoscopeButton.tap()
        editButton.tap()
        doneButton.tap()
        ttgc7swiftui32navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["CREATE"]/*[[".otherElements[\"CREATE\"].buttons[\"CREATE\"]",".buttons[\"CREATE\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        backButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["pets"]/*[[".cells.buttons[\"pets\"]",".buttons[\"pets\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["Swipe right to recuperate given patient"].tap()
        editButton.tap()
        doneButton.tap()
        onboardButton.tap()
        closeButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Tsonara"]/*[[".cells.buttons[\"Tsonara\"]",".buttons[\"Tsonara\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        backButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["about"]/*[[".cells.buttons[\"about\"]",".buttons[\"about\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton/*@START_MENU_TOKEN@*/.press(forDuration: 1.2);/*[[".tap()",".press(forDuration: 1.2);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
