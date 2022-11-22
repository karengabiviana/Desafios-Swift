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
        //configs
        
        setConstraintsSubmit()
    }
    
    func configResult() {
        //configs
        
        setConstraintsResult()
    }
    
    //Constraints
    func setConstraintsTextField() {
        //constraints
    }

    func setConstraintsSubmit() {
        //constraints
    }
    
    func setConstraintsResult() {
        //constraints
    }
    
   
}

