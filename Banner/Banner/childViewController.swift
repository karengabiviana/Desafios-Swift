//
//  childViewViewController.swift
//  Banner
//
//  Created by Karen Oliveira on 02/09/22.
//

import UIKit

class childViewController: UIViewController {
    
    let leftColumn = UIView()
    let rightColumn = UIView()
    let titleBanner = UILabel()
    let subtitleBanner = UILabel()
    let buttonBanner = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        columns()
        labelsAndButton()
    }
    
    
    func columns() {
        
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 16
 
        view.addSubview(leftColumn)
//        leftColumn.backgroundColor = .red
        
        view.addSubview(rightColumn)
        rightColumn.backgroundColor = .magenta
        
        configConstrainsts()

    }
    
    func configConstrainsts() {
        leftColumn.translatesAutoresizingMaskIntoConstraints = false
        rightColumn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftColumn.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            leftColumn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            leftColumn.trailingAnchor.constraint(equalTo: rightColumn.leadingAnchor, constant: -16),
            leftColumn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            rightColumn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            rightColumn.topAnchor.constraint(equalTo: leftColumn.topAnchor),
            rightColumn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            rightColumn.leadingAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor, constant: 8),
            rightColumn.bottomAnchor.constraint(equalTo: leftColumn.bottomAnchor),
            
        ])
        
    }
    
    func labelsAndButton() {
        
        leftColumn.addSubview(titleBanner)
        titleBanner.text = "Venda mais com sua chave Pix na SumUp!"
        titleBanner.font = UIFont.boldSystemFont(ofSize: 18)
        titleBanner.textAlignment = .left
        titleBanner.numberOfLines = 0
        titleBanner.adjustsFontSizeToFitWidth = true
        
        
        leftColumn.addSubview(subtitleBanner)
        subtitleBanner.text = "É mais facilidade para suas vendas"
        subtitleBanner.font = UIFont.systemFont(ofSize: 14)
        subtitleBanner.textAlignment = .left
        subtitleBanner.numberOfLines = 0
        subtitleBanner.adjustsFontSizeToFitWidth = true
        
        leftColumn.addSubview(buttonBanner)
        buttonBanner.setTitle("Cadastrar Chave Pix", for: .normal)
       
       
        configLabels()
        
    }
    
    func configLabels() {
        titleBanner.translatesAutoresizingMaskIntoConstraints = false
        subtitleBanner.translatesAutoresizingMaskIntoConstraints = false
        
        // labels
        NSLayoutConstraint.activate([
            titleBanner.topAnchor.constraint(equalTo: leftColumn.topAnchor, constant: 8),
            
            subtitleBanner.topAnchor.constraint(equalTo: titleBanner.bottomAnchor, constant: 8)
        ])
        
        //button
    
        buttonBanner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            buttonBanner.topAnchor.constraint(equalTo: subtitleBanner.bottomAnchor, constant: 16)
        ])
    }

}
