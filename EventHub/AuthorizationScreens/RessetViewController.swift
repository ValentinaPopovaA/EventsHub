//
//  RessetViewController.swift
//  EventHub
//
//  Created by Максим on 22.11.2024.
//

import UIKit

class RessetViewController: UIViewController {

    
    // MARK: - UI Components
    
    let emailField = UITextField()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "AirbnbCereal_W_Bk", size: 15)
        label.text = "Please enter your email address to \nrequest a password reset"
        return label
    }()

    
    
    private let sendButton = UIButton.makePurpleButton(label: "SENT", target: self, action: #selector(SendButtonTapped))
    
    
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    
    // MARK: - UI Setup
    private func setupUI() {
        
        self.view.backgroundColor = .systemBackground

        emailField.configureTextField(placeholder: "abc@email.com", icon: UIImage(named: "Mail"))
        
        self.view.addSubview(label)
        self.view.addSubview(emailField)
        self.view.addSubview(sendButton)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 138),
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),

            emailField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 26),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            
            sendButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 40),
            sendButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 52),
            sendButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -52),
           
            
           
        ])
    }
    
    // MARK: - Selectors
    
    @objc func SendButtonTapped() {
        print("Send button tapped!")
        let email = self.emailField.text ?? ""
 
        if !Validator.isValidEmail(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            guard let self = self else {return}
            if let error = error {
                AlertManager.showForgotPasswordErrorSending(on: self, with: error)
                return
            }
            
            AlertManager.showPasswordResetSent(on: self)
        }

    }
}


//#Preview {RessetViewController()}
