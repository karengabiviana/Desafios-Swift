//
//  Logic.swift
//  App Prime Numbers
//
//  Created by Karen Oliveira on 23/11/22.
//

import Foundation

protocol PresenterProtocol: AnyObject {
    func didEdit(newValue: String)
    func didTapSubmit()
}

class Presenter: PresenterProtocol {

    func didEdit(newValue: String) {

    }

    @objc func didTapSubmit() {
        // gets number of textfield and convert to Int
        let number = Int(ViewController(presenter: Presenter()).field.text ?? "0") ?? 0
        //  gets the prime factor of the number
        let result = primeFactors(of: number)
        // gets the arrays of Int and transforme in editaded String
        let strResult = joinedPrimes(primeList: result)
        // shows in screen the result
        ViewController(presenter: Presenter()).resultLabel.text = strResult
        // clears the textfield
        ViewController(presenter: Presenter()).field.clearsOnInsertion = true

    }
    // decompoe
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

    func joinedPrimes(primeList: [Int]) -> String {
        primeList.map { String($0) }.joined(separator: ", ")

    }
}
