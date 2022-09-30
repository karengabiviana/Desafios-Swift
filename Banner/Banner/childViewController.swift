//
//  childViewViewController.swift
//  Banner
//
//  Created by Karen Oliveira on 02/09/22.
//

import UIKit

class childViewController: UIView {
    
    let leftColumn = UIView()
    let rightColumn = UIView()
    let titleBanner = UILabel()
    let subtitleBanner = UILabel()
    let buttonBanner = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        columns()
        labelsAndButton()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func columns() {
        
        backgroundColor = .lightGray
        layer.cornerRadius = 16
 
        addSubview(leftColumn)
//        leftColumn.backgroundColor = .red
        
        addSubview(rightColumn)
        rightColumn.backgroundColor = .magenta
        
        configConstrainsts()

    }
    
    func configConstrainsts() {
        leftColumn.translatesAutoresizingMaskIntoConstraints = false
        rightColumn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 180),
            
            leftColumn.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            leftColumn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            leftColumn.trailingAnchor.constraint(equalTo: rightColumn.leadingAnchor, constant: -16),
            leftColumn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            rightColumn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            rightColumn.topAnchor.constraint(equalTo: leftColumn.topAnchor),
            rightColumn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            rightColumn.leadingAnchor.constraint(lessThanOrEqualTo: centerXAnchor, constant: 8),
            rightColumn.bottomAnchor.constraint(equalTo: leftColumn.bottomAnchor),
            
        ])
        
    }
    
    func labelsAndButton() {
        
        leftColumn.addSubview(titleBanner)
        titleBanner.text = "Venda mais com sua chave Pix na SumUp!"
        titleBanner.font = UIFont.boldSystemFont(ofSize: 18)
        titleBanner.textAlignment = .left
        titleBanner.numberOfLines = 2
        titleBanner.adjustsFontSizeToFitWidth = true
        
        leftColumn.addSubview(subtitleBanner)
        subtitleBanner.text = "É mais facilidade para suas vendas"
        subtitleBanner.font = UIFont.systemFont(ofSize: 14)
        subtitleBanner.textAlignment = .left
        subtitleBanner.numberOfLines = 2
        subtitleBanner.adjustsFontSizeToFitWidth = true
        
        leftColumn.addSubview(buttonBanner)
        buttonBanner.setTitle("Cadastrar Chave Pix", for: .normal)
       
       
        configLabels()
        
    }
    
    func configLabels() {
        // labels
        titleBanner.translatesAutoresizingMaskIntoConstraints = false
        subtitleBanner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleBanner.topAnchor.constraint(equalTo: leftColumn.topAnchor, constant: 8),
            titleBanner.leadingAnchor.constraint(equalTo: leftColumn.leadingAnchor),
            titleBanner.trailingAnchor.constraint(equalTo: leftColumn.trailingAnchor),
            
            subtitleBanner.topAnchor.constraint(equalTo: titleBanner.bottomAnchor, constant: 8),
            subtitleBanner.leadingAnchor.constraint(equalTo: leftColumn.leadingAnchor),
            subtitleBanner.trailingAnchor.constraint(equalTo: leftColumn.trailingAnchor),
        ])
        
        //button
        
        buttonBanner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            buttonBanner.topAnchor.constraint(greaterThanOrEqualTo: subtitleBanner.bottomAnchor, constant: 16),
            buttonBanner.bottomAnchor.constraint(equalTo: leftColumn.bottomAnchor, constant: -8)
        ])
    }

}
