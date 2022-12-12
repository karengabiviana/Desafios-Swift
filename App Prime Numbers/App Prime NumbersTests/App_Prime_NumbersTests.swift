//
//  App_Prime_NumbersTests.swift
//  App Prime NumbersTests
//
//  Created by Karen Oliveira on 21/11/22.
//

import XCTest
@testable import App_Prime_Numbers

class AppPrimeNumbersDecomposingTests: XCTestCase {
    
    let presenter = Presenter()
    
    func testDecomposingZero() {
        XCTAssertEqual(presenter.decomposing(number: 0), [])
    }
    
    func testDecomposingValidNumber() {
        XCTAssertEqual(presenter.decomposing(number: 10), [2,5])
    }
    
    func testDecomposing1() {
        XCTAssertEqual(presenter.decomposing(number: 1), [])
    }
    
    func testDecomposingNegative() {
        XCTAssertEqual(presenter.decomposing(number: -100), [])
    }
    
    func testDecomposing221() {
        XCTAssertEqual(presenter.decomposing(number: 221), [13, 17])
    }
    
    func testDecomposing9() {
        XCTAssertEqual(presenter.decomposing(number: 9), [3, 3])
    }
    
    func ​testDecomposing1024() {
        XCTAssertEqual(presenter.decomposing(number: 1024), [2, 2, 2, 2, 2, 2, 2, 2, 2, 2])
    }
    
    func testDecomposing1000() {
        XCTAssertEqual(presenter.decomposing(number: 1000), [2, 2, 2, 5, 5, 5])
    }
    
    func testLargePrime() {
        measure {
            XCTAssertEqual(presenter.decomposing(number: 5003), [5003])
        }
    }
    
    func testLargeNumber() {
        measure {
            XCTAssertEqual(presenter.decomposing(number: 5005), [5, 7, 11, 13])
        }
    }
    
    func testVeryLargeNumber() {
        measure {
            XCTAssertEqual(presenter.decomposing(number: 614889782588491410), [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47])
        }
    }
    
}
