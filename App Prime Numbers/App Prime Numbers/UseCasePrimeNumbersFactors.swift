//
//  UseCasePrimeNumbersFactors.swift
//  App Prime Numbers
//
//  Created by Karen Oliveira on 04/08/23.
//

import Foundation

protocol UseCasePrimeNumbersFactorsProtocol: AnyObject {
    func primeFactors(of number: Int) -> [Int]
}

class UseCasePrimeNumbersFactors: UseCasePrimeNumbersFactorsProtocol {

    func primeFactors(of number: Int) -> [Int] {
        var factors: [Int] = []
        var dividend = number
        var divider = 2

        while dividend > 1 {
            while dividend % divider == 0 {
                factors.append(divider)
                dividend /= divider
            }
            divider += 1
        }
        return factors
    }
}
