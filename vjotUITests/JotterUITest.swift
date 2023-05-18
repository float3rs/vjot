//
//  jotterUITest.swift
//  vjotUITests
//
//  Created by Nikolaos Saridakis on 29/4/23.
//

import XCTest

final class JotterUITest: XCTestCase {

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
        app.buttons["WIPE"]/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 0.5);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        app.buttons["BOOTSTRAP"].tap()
        sleep(60)
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["jotter"].tap()
//        elementsQuery.textFields["one word description"].tap()
        elementsQuery.textFields["description"].tap()
        
        let jotterElementsQuery = scrollViewsQuery.otherElements.containing(.staticText, identifier:"jotter")
        jotterElementsQuery.children(matching: .button).matching(identifier: "checkmark.rectangle").element(boundBy: 0).tap()
        
        let jotterElement = scrollViewsQuery.otherElements.containing(.staticText, identifier:"jotter").element
        jotterElement.swipeUp()
        elementsQuery.staticTexts["SNAPS"].tap()
        jotterElement.swipeUp()
        
//        let element = jotterElementsQuery.children(matching: .other).element(boundBy: 0)
//        element.children(matching: .button).matching(identifier: "Close").element(boundBy: 0).tap()
//        element.tap()
//        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Back"].tap()
//        jotterElement.swipeUp()
        
        let element2 = jotterElementsQuery.children(matching: .other).element(boundBy: 1)
        let _ = element2.children(matching: .button).matching(identifier: "Play").element(boundBy: 0)
//        playButton.tap()
//        playButton.tap()
        jotterElement.swipeUp()
        jotterElement.swipeUp()
//        elementsQuery.staticTexts["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."].tap()
//        let scrollViewsQuery = app.scrollViews
//        let jotterElement = scrollViewsQuery.otherElements.containing(.staticText, identifier:"jotter").element
//        scrollViewsQuery.otherElements.staticTexts["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. €16.00"].tap()
//        element2.children(matching: .button).matching(identifier: "xmark.rectangle").element(boundBy: 0).tap()
        jotterElement.swipeUp()
//        elementsQuery.textFields["idea"].tap()
        elementsQuery.textFields["action"].tap()
        jotterElementsQuery.children(matching: .button).matching(identifier: "checkmark.rectangle").element(boundBy: 1).tap()
        jotterElement.swipeUp()
        elementsQuery.switches["triangle"].tap()
        elementsQuery.buttons["associated, patient"].tap()
//        app.staticTexts["patient"].tap()
        app.staticTexts["FOR INCIDENT"].tap()
        app.buttons["Close"].tap()
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
