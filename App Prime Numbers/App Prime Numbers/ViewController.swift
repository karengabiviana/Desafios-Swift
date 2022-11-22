//
//  ViewController.swift
//  App Prime Numbers
//
//  Created by Karen Oliveira on 21/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    let textField = UITextField()
    let submit = UIButton()
    let result = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTextField()
        configSubmit()
        configResult()
    }
    
    //Configurations
    func configTextField() {
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.borderStyle = .line
        textField.placeholder = "Put a number here..."
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        view.addSubview(textField)
        
        setConstraintsTextField()
    }
    
    func configSubmit() {
        submit.setTitle("Submit", for: .normal)
        submit.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        submit.backgroundColor = .gray
        submit.tintColor = .black
        view.addSubview(submit)
        
        setConstraintsSubmit()
    }
    
    func configResult() {
        result.text = "Prime numbers will be here"
        result.textColor = .black
        result.textAlignment = .center
        view.addSubview(result)
        
        setConstraintsResult()
    }
    
    //Constraints
    func setConstraintsTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setConstraintsSubmit() {
        submit.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            submit.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            submit.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            submit.heightAnchor.constraint(equalToConstant: 40),
            submit.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setConstraintsResult() {
        result.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            result.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 16),
            result.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            result.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            result.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

}

