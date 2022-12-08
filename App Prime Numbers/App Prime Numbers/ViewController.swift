//
//  ViewController.swift
//  App Prime Numbers
//
//  Created by Karen Oliveira on 21/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    let field = UITextField()
    let submitButton = UIButton()
    var resultLabel = UILabel()
    let presenter = Presenter()
    
//    let presenter: Presenter
    
    var number: Int {
        guard let fieldText = field.text else {
            return 0
        }
        
        return Int(fieldText) ?? 0
    }

//    init(presenter: Presenter) {
//        self.presenter = presenter
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTextField()
        configSubmit()
        configResult()
    }
    
    //Configurations
    func configTextField() {
        field.textColor = .black
        field.backgroundColor = .white
        field.borderStyle = .line
        field.placeholder = "Put a number here..."
        field.clearButtonMode = .whileEditing
        field.keyboardType = .numberPad
        view.addSubview(field)
        
        setConstraintsField()
    }
    
    func configSubmit() {
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        submitButton.backgroundColor = .gray
        submitButton.tintColor = .black
        submitButton.addTarget(self, action: #selector(conectThings), for: .allEvents)
        view.addSubview(submitButton)
        
        setConstraintsSubmit()
    }
    
    func configResult() {
        resultLabel.text = "Prime numbers will be here"
        resultLabel.textColor = .black
        resultLabel.textAlignment = .center
        view.addSubview(resultLabel)
        
        setConstraintsResult()
    }
    
    //Constraints
    func setConstraintsField() {
        field.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            field.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            field.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            field.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            field.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setConstraintsSubmit() {
        submitButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 16),
            submitButton.centerXAnchor.constraint(equalTo: field.centerXAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            submitButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setConstraintsResult() {
        resultLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 16),
            resultLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            resultLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            resultLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func joinedPrimes(primeList: [Int]) -> String {
        primeList.map { String($0) }.joined(separator: ", ")
    }
    
    @objc func conectThings() {
        //call decomposing(number from getNumberFromField)
        let primeList = presenter.decomposing(number: number)
        //show the result in result label
        resultLabel.text = joinedPrimes(primeList: primeList)
    }

}

