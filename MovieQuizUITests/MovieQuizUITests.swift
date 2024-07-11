//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Марат Хасанов on 09.07.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        
        app = nil
    
    }
    
    
    func testScreenCast() throws { }
    
    func testExample() throws {

        let app = XCUIApplication()
        app.launch()

    }
    
    func testLabel() {
        sleep(4)
        let firstLabel = app.staticTexts["Index"]
        app.buttons["Yes"].tap()
        sleep(4)
        XCTAssertEqual(firstLabel.label, "2/10")
    }
    
    func testNotButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Нет"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
