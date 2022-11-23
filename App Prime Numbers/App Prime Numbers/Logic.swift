//
//  Logic.swift
//  App Prime Numbers
//
//  Created by Karen Oliveira on 23/11/22.
//

import Foundation
import ImageIO

class Logic {
    
    func decomposing(number:Int) -> [Int] {
        
        if number > 1 {
            return createDecomposerList(number: number)
        }
        
        return []
    }

    func createDecomposerList(number:Int) -> [Int] {
        var primes: [Int] = []
        var workNumber = number
        
        var n = 2
        while workNumber >= 2 {
            while workNumber % n == 0 {
                primes.append(n)
                workNumber = workNumber / n
            }
            n += 1
        }
        return primes
    }
    
}
