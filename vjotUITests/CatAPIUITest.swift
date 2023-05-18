//
//  CatAPIUITest.swift
//  vjotUITests
//
//  Created by Nikolaos Saridakis on 29/4/23.
//

import XCTest

final class CatAPIUITest: XCTestCase {

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
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["origamiCat, images"]/*[[".cells.buttons[\"origamiCat, images\"]",".buttons[\"origamiCat, images\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["search"]/*[[".cells.buttons[\"search\"]",".buttons[\"search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.buttons["1"].tap()
        
        let incrementButton = elementsQuery.steppers["1"].buttons["Increment"]
        incrementButton.tap()
        
        let button = elementsQuery.buttons["2"]
        button.tap()
        
        let settingsButton = elementsQuery.buttons["Settings"]
        settingsButton.tap()
        
        let searchElementsQuery = scrollViewsQuery.otherElements.containing(.staticText, identifier:"search")
        searchElementsQuery.children(matching: .staticText).matching(identifier: "optionally, search").element(boundBy: 0).tap()
        searchElementsQuery.children(matching: .staticText).matching(identifier: "optionally, search").element(boundBy: 1).tap()
        elementsQuery.staticTexts["optionally, exclude"].tap()
        
        let ttgc7swiftui32navigationstackhostingNavigationBar = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]
        let backToSearchAdjustButton = ttgc7swiftui32navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["BACK TO SEARCH, Adjust"]/*[[".otherElements[\"BACK TO SEARCH, Adjust\"].buttons[\"BACK TO SEARCH, Adjust\"]",".buttons[\"BACK TO SEARCH, Adjust\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        backToSearchAdjustButton.tap()
        
        let backButton = ttgc7swiftui32navigationstackhostingNavigationBar.buttons["Back"]
        backButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["find"]/*[[".cells.buttons[\"find\"]",".buttons[\"find\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery.textFields["id"].tap()
        settingsButton.tap()
        elementsQuery.staticTexts["options"].tap()
        backToSearchAdjustButton.tap()
        backButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["upload"]/*[[".cells.buttons[\"upload\"]",".buttons[\"upload\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery.staticTexts["upload"].tap()
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
