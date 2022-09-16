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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        view.addSubview(leftColumn)
        view.addSubview(rightColumn)
        
        setColumns()
    }
    
    func setColumns() {
        leftColumn.backgroundColor = .red
        
        rightColumn.backgroundColor = .magenta
        
        configConstrainsts()
    }
    
    func configConstrainsts() {
        leftColumn.translatesAutoresizingMaskIntoConstraints = false
        rightColumn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            leftColumn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            leftColumn.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            leftColumn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            leftColumn.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            leftColumn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            rightColumn.topAnchor.constraint(equalTo: leftColumn.topAnchor),
            rightColumn.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            rightColumn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            rightColumn.bottomAnchor.constraint(equalTo: leftColumn.bottomAnchor)
        ])
    }

}
