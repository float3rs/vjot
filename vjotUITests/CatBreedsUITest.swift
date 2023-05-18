//
//  CatBreedsUITest.swift
//  vjotUITests
//
//  Created by Nikolaos Saridakis on 29/4/23.
//

import XCTest

final class CatBreedsUITest: XCTestCase {

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
        
//        let app = XCUIApplication()
//        app.launchArguments += ["-AppleLanguages", "(en)"]
//        app.launchArguments += ["-AppleLocale", "en-US"]
//        app.launch()
//        app.buttons["WIPE"]/*@START_MENU_TOKEN@*/.press(forDuration: 0.5);/*[[".tap()",".press(forDuration: 0.5);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        app.buttons["BOOTSTRAP"].tap()
//        sleep(10)
        
        
        
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(en)"]
        app.launchArguments += ["-AppleLocale", "en-US"]
        app.launch()
        app.buttons["WIPE"]/*@START_MENU_TOKEN@*/.press(forDuration: 0.5);/*[[".tap()",".press(forDuration: 0.5);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["BOOTSTRAP"].tap()
        sleep(60)
        app.tabBars["Tab Bar"].buttons["breeds"].tap()
        
        let app2 = app
        app2.collectionViews/*@START_MENU_TOKEN@*/.buttons["origamiCat, bookz2"]/*[[".cells.buttons[\"origamiCat, bookz2\"]",".buttons[\"origamiCat, bookz2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app2.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Refresh"]/*[[".otherElements[\"Refresh\"].buttons[\"Refresh\"]",".buttons[\"Refresh\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .button).element.tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["breed:"].tap()
        elementsQuery.staticTexts["Abyssinian"].tap()
        
        let breedElement = scrollViewsQuery.otherElements.containing(.staticText, identifier:"breed:").element
        breedElement.swipeUp()
        elementsQuery.staticTexts["description"].tap()
        elementsQuery.staticTexts["origin:"].tap()
        elementsQuery.staticTexts["country codes:"].tap()
        elementsQuery.staticTexts["country code:"].tap()
        breedElement.swipeUp()
        elementsQuery.staticTexts["temperament"].tap()
        breedElement.swipeUp()
        elementsQuery.staticTexts["adaptability:"].tap()
        elementsQuery.staticTexts["energy level:"].tap()
        elementsQuery.staticTexts["affection level:"].tap()
        elementsQuery.staticTexts["stranger friendly:"].tap()
        elementsQuery.staticTexts["child friendly:"].tap()
        elementsQuery.staticTexts["dog friendly:"].tap()
        elementsQuery.staticTexts["grooming:"].tap()
        elementsQuery.staticTexts["health issues:"].tap()
        elementsQuery.staticTexts["intelligence:"].tap()
        elementsQuery.staticTexts["shedding level:"].tap()
        elementsQuery.staticTexts["social needs:"].tap()
        elementsQuery.staticTexts["vocalisation:"].tap()
        elementsQuery.staticTexts["lifespan:"].tap()
        breedElement.swipeUp()
        elementsQuery.staticTexts["indoor:"].tap()
        elementsQuery.staticTexts["lap:"].tap()
        elementsQuery.staticTexts["experimental:"].tap()
        elementsQuery.staticTexts["hairless:"].tap()
        elementsQuery.staticTexts["natural:"].tap()
        elementsQuery.staticTexts["rare:"].tap()
        elementsQuery.staticTexts["rex:"].tap()
        elementsQuery.staticTexts["suppressed tail:"].tap()
        elementsQuery.staticTexts["short legs:"].tap()
        elementsQuery.staticTexts["hypoallergenic:"].tap()
        elementsQuery.staticTexts["weight:"].tap()
        breedElement.swipeDown()
        breedElement.swipeUp()
        elementsQuery.buttons["photo.on.rectangle.angled"].tap()
        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Back"].tap()
                
                        
        
        
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
