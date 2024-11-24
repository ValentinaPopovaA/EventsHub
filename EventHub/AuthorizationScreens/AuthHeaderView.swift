//
//  AuthHeaderView.swift
//  EventHub
//
//  Created by Максим on 22.11.2024.
//

import UIKit

class AuthHeaderView: UIView {
    
    let usernameField = UITextField()
    let emailField = UITextField()
   
    
    // MARK: - UI Components
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon")
        
        return iv
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 35, weight: .medium)
        label.text = "Error"
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.text = "Error"
        return label
    }()
    
    
    
    
    
    // MARK: - LifeCycle
    
    
    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(logoImageView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)

        usernameField.configureTextField(placeholder: "Full name", icon: UIImage(named:"Profile"))
        emailField.configureTextField(placeholder: "abc@email.com", icon: UIImage(named: "Mail"))
        

        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        

        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 20),
            self.logoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 65),
            self.logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 45)
        ])
        
        NSLayoutConstraint.activate([
            self.subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            self.subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30)
        ])
        
    }
}


