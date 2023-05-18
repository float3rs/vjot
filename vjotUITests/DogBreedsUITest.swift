//
//  DogBreedsUITest.swift
//  vjotUITests
//
//  Created by Nikolaos Saridakis on 29/4/23.
//

import XCTest

final class DogBreedsUITest: XCTestCase {

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
        app.tabBars["Tab Bar"].buttons["breeds"].tap()
        
        let app2 = app
        app2.collectionViews/*@START_MENU_TOKEN@*/.buttons["origamiDog, bookz2"]/*[[".cells.buttons[\"origamiDog, bookz2\"]",".buttons[\"origamiDog, bookz2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app2.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Refresh"]/*[[".otherElements[\"Refresh\"].buttons[\"Refresh\"]",".buttons[\"Refresh\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let button = app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .button).element
        button.tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["breed group:"].tap()
        
        let affenpinscherElement = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Affenpinscher").element
        affenpinscherElement.swipeUp()
        elementsQuery.staticTexts["bred for"].tap()
        elementsQuery.staticTexts["lifespan:"].tap()
        elementsQuery.staticTexts["temperament"].tap()
        affenpinscherElement.swipeUp()
        elementsQuery.staticTexts["origin:"].tap()
        elementsQuery.staticTexts["height:"].tap()
        elementsQuery.staticTexts["weight:"].tap()
        affenpinscherElement/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeDown()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        elementsQuery.buttons["photo.on.rectangle.angled"].tap()
        
        let ttgc7swiftui32navigationstackhostingNavigationBar = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]
        let backButton = ttgc7swiftui32navigationstackhostingNavigationBar.buttons["Back"]
        backButton.tap()
        backButton.tap()
        ttgc7swiftui32navigationstackhostingNavigationBar.searchFields["Search by Breed"].tap()
        ttgc7swiftui32navigationstackhostingNavigationBar.buttons["Cancel"].tap()
        button.tap()
                
        
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
