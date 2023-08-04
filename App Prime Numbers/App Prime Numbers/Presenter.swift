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

    weak var view: ViewProtocol?
    var useCase: UseCasePrimeNumbersFactorsProtocol?

    var value = ""

    func didEdit(newValue: String) {
        value = newValue
    }

    func didTapSubmit() {
        // gets number of textfield and convert to Int
        guard let number = Int(value) else {
            view?.show(result: "Invalid Value!")
            return
        }
        //  gets the prime factor of the number
        guard let result = useCase?.primeFactors(of: number) else {
            view?.show(result: "Error")
            return }
        // gets the arrays of Int and transforme in editaded String
        let strResult = joinedPrimes(primeList: result)
        // shows in screen the result
        view?.show(result:strResult)
    }

    func joinedPrimes(primeList: [Int]) -> String {
        primeList.map { String($0) }.joined(separator: ", ")

    }
}
