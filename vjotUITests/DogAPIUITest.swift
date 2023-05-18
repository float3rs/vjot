//
//  ImagesDogUITest.swift
//  vjotUITests
//
//  Created by Nikolaos Saridakis on 29/4/23.
//

import XCTest

final class DogAPIUITest: XCTestCase {

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
        app.tabBars["Tab Bar"].buttons["images"].tap()
        
        let collectionViewsQuery2 = app.collectionViews
        let origamidogImagesButton = collectionViewsQuery2/*@START_MENU_TOKEN@*/.buttons["origamiDog, images"]/*[[".cells.buttons[\"origamiDog, images\"]",".buttons[\"origamiDog, images\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        origamidogImagesButton.tap()
        
        let collectionViewsQuery = collectionViewsQuery2
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["search"]/*[[".cells.buttons[\"search\"]",".buttons[\"search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let incrementButton = elementsQuery.steppers["1"].buttons["Increment"]
        incrementButton.tap()
        elementsQuery.steppers["2"].buttons["Increment"].tap()
        elementsQuery.steppers["3"].buttons["Decrement"].tap()
        
        let button = elementsQuery.buttons["2"]
        button.tap()
        
        let settingsButton = elementsQuery.buttons["Settings"]
        settingsButton.tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"search").children(matching: .button).matching(identifier: "tag.slash").element(boundBy: 0).tap()
        elementsQuery.buttons["tag.slash"].tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"search").element.swipeUp()
        
        let app2 = app
        app2.scrollViews.otherElements/*@START_MENU_TOKEN@*/.pickerWheels["medium"].press(forDuration: 1.9);/*[[".pickers.pickerWheels[\"medium\"]",".tap()",".press(forDuration: 1.9);",".pickerWheels[\"medium\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        
        let backToSearchAdjustButton = app2.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["BACK TO SEARCH, Adjust"]/*[[".otherElements[\"BACK TO SEARCH, Adjust\"].buttons[\"BACK TO SEARCH, Adjust\"]",".buttons[\"BACK TO SEARCH, Adjust\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        backToSearchAdjustButton.tap()
        
        let backButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Back"]
        backButton.tap()
        
        let findButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["find"]/*[[".cells.buttons[\"find\"]",".buttons[\"find\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        findButton.tap()
        
        let idTextField = elementsQuery.textFields["id"]
        idTextField.tap()
        settingsButton.tap()
        backToSearchAdjustButton.tap()
        backButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["upload"]/*[[".cells.buttons[\"upload\"]",".buttons[\"upload\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        
        let favButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["fav"]/*[[".cells.buttons[\"fav\"]",".buttons[\"fav\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        favButton.tap()
        
        let yoursButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["yours"]/*[[".cells.buttons[\"yours\"]",".buttons[\"yours\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        yoursButton.tap()
        backButton.tap()
        
        let everyoneSButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["everyone's"]/*[[".cells.buttons[\"everyone's\"]",".buttons[\"everyone's\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        everyoneSButton.tap()
        backButton.tap()
        
        let preciseButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["precise"]/*[[".cells.buttons[\"precise\"]",".buttons[\"precise\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        preciseButton.tap()
        backButton.tap()
        backButton.tap()
        favButton.swipeUp()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["vote"]/*[[".cells.buttons[\"vote\"]",".buttons[\"vote\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        yoursButton.tap()
        backButton.tap()
        everyoneSButton.tap()
        backButton.tap()
        preciseButton.tap()
        backButton.tap()
        backButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["delete"]/*[[".cells.buttons[\"delete\"]",".buttons[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        incrementButton.tap()
        button.tap()
        settingsButton.tap()
        backToSearchAdjustButton.tap()
        backButton.tap()
        backButton.tap()
        origamidogImagesButton.tap()
        findButton.tap()
        idTextField.tap()
        elementsQuery.buttons["Search"].tap()
        backButton.tap()
        backButton.tap()
                
                        
                
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
