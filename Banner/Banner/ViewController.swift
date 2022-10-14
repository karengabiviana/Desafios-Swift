//
//  ViewController.swift
//  Banner
//
//  Created by Karen Oliveira on 19/08/22.
//

import CircuitUI
import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    let titleLabel = UILabel()
    lazy var bannerView: UIView = {
        let buttonConfiguration = NotificationBannerView.ButtonConfiguration(title: "Cadastrar Chave Pix", buttonType: .tertiary) {
            print("Cliquei!")
        }
        let image = UIImage(named: "PixKeyBannerIllustration")
        let configuration = NotificationBannerView.Configuration(title: "Venda mais com sua chave Pix na SumUp!", body: "É mais facilidade para suas vendas", buttonConfiguration: buttonConfiguration, image: image, variant: .promotional )
        return NotificationBannerView(configuration: configuration)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitle()
        addBannerView()
    }
    
    func configTitle() {
        view.addSubview(titleLabel)
        titleLabel.text = "Banner"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        
        setTitleConstraints()
        
    }
    func setTitleConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func addBannerView() {
        view.addSubview(bannerView)
        setBannerViewConstrainsts()
    }
    
    func setBannerViewConstrainsts() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            bannerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
