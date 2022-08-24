//
//  Decomposing_into_Prime_NumberTests.swift
//  Decomposing into Prime NumberTests
//
//  Created by Karen Oliveira on 18/08/22.
//

import XCTest
@testable import Decomposing_into_Prime_Number


func decomposing(number:Int) -> [Int] {
    
    if number > 1 {
        return createDecomposerList(number: number)
    }
    
    return []
}

func createDecomposerList(number:Int) -> [Int] {
    var primes: [Int] = []
    var workNumber = number
    
    for n in 2...number {
        if isPrime(n) {
            while workNumber % n == 0{
                primes.append(n)
                workNumber = workNumber / n
            }
        }
    }
    return primes
}

func isPrime(_ number: Int) -> Bool {
    
    var divide: [Int] = []
    
    if number <= 1{
        return false
    }
    
    for i in 1...number {
        if number % i == 0 {
            divide.append(i)
        }
    }
    
    if divide.count == 2 {
        return true
    } else {
        return false
    }
}




class Decomposing_into_Prime_NumberTests: XCTestCase {
    
    func testIsPrime() {
        XCTAssertTrue(isPrime(1607))
    }
    
    func testZeroIsPrime() {
        XCTAssertFalse(isPrime(0))
    }
    
    func testDecomposingZero() {
        XCTAssertEqual(decomposing(number: 0), [])
    }
    
    func testDecomposingValidNumber() {
        XCTAssertEqual(decomposing(number: 10), [2,5])
    }
    
    func testDecomposing1() {
        XCTAssertEqual(decomposing(number: 1), [])
    }
    
    func testDecomposingNegative() {
        XCTAssertEqual(decomposing(number: -100), [])
    }
}
