//
//  ViewController.swift
//  App Prime Numbers
//
//  Created by Karen Oliveira on 21/11/22.
//

import UIKit

protocol ViewProtocol: AnyObject {
    func show(result: String)
}

class ViewController: UIViewController, ViewProtocol {

    let presenter: PresenterProtocol

    var number: Int {
        guard let fieldText = field.text else {
            return 0
        }

        return Int.init(fieldText) ?? 0
    }

    lazy var field: UITextField = {
        let field = UITextField()
        field.textColor = .black
        field.backgroundColor = .white
        field.borderStyle = .line
        field.placeholder = "Put a number here"
        field.clearButtonMode = .whileEditing
        field.addTarget(self, action: #selector(didEditField), for: .editingChanged)
        return field
    }()

    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = .gray
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapSubmit), for: .touchDown)
        return button
    }()

    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Prime numbers will be here"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    init(presenter: PresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(field)
        view.addSubview(submitButton)
        view.addSubview(resultLabel)

        setConstraintsField()
        setConstraintsSubmit()
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

    func show(result: String) {
        resultLabel.text = result
    }

    @objc func didEditField() {
        presenter.didEdit(newValue: field.text ?? "")
    }

    @objc func didTapSubmit() {
        presenter.didTapSubmit()
    }
}
