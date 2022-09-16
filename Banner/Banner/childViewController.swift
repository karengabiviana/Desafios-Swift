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
            leftColumn.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            leftColumn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            leftColumn.trailingAnchor.constraint(equalTo: rightColumn.leadingAnchor, constant: -16),
            leftColumn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            rightColumn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            rightColumn.topAnchor.constraint(equalTo: leftColumn.topAnchor),
            rightColumn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            rightColumn.leadingAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor, constant: 8),
            rightColumn.bottomAnchor.constraint(equalTo: leftColumn.bottomAnchor)
        ])
    }

}
