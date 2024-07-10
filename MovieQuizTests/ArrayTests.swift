//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Марат Хасанов on 09.07.2024.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        
        //When
        let value = array[safe: 2]
        
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOurRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        
        //When
        let value = array[safe: 20]
        
        //Then
        XCTAssertNotNil(value)
    }
}

//GWT (Give - When - Then) (Дано - Когда - Тогда)
