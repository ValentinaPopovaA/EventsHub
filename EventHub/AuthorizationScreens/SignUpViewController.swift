//
//  SingInViewController.swift
//  EventHub
//
//  Created by Мах on 17.11.2024.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let usernameField = UITextField()
    let emailField = UITextField()
    let passwordField = UITextField()
    let confirmField = UITextField()
    
   
    private let signUpButton = UIButton.makePurpleButton(label: "SING UP", target: self, action: #selector(signUpButtonTapped))
    
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginGoogleButton = UIButton.makeWhiteButton(label: "Login with Google", target: self, action: #selector(googleButtonTapped))
    
    private let signInButton = CustomButton(title: "Sing in", isBlue: true, fontSize: .small)
    
    
    private let alreadyLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        self.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        
    }
    
    
    // MARK: - UI Setup
    
    func setupUI() {
//MARK: - TextField
        
        usernameField.configureTextField(placeholder: "Full name", icon: UIImage(named:"Profile"))
        emailField.configureTextField(placeholder: "abc@email.com", icon: UIImage(named: "Mail"))
        passwordField.configurePasswordField(placeholder: "Your password")
        confirmField.configurePasswordField(placeholder: "Confirm password")
        
        
        let stackField = UIStackView(arrangedSubviews: [usernameField, emailField, passwordField, confirmField ])
        stackField.axis = .vertical
        stackField.spacing = 19
        stackField.translatesAutoresizingMaskIntoConstraints = false
                        
        view.addSubview(stackField)
        
        NSLayoutConstraint.activate([
            stackField.topAnchor.constraint(equalTo: view.topAnchor, constant: 146),
            stackField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            stackField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28)
        ])
        
//MARK: - Buttons
        
        let stackButton = UIStackView(arrangedSubviews: [signUpButton,orLabel,  loginGoogleButton])
        stackButton.axis = .vertical
        stackButton.alignment = .center
        stackButton.spacing = 50
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackButton)
        
        NSLayoutConstraint.activate([
            stackButton.topAnchor.constraint(equalTo: stackField.bottomAnchor, constant: 50),
            stackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        
        let downStack = UIStackView(arrangedSubviews: [alreadyLabel, signInButton])
        downStack.axis = .horizontal
        downStack.alignment = .center
        downStack.spacing = 7
        downStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(downStack)
        
        NSLayoutConstraint.activate([
            downStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        
        
    }
    
    
    
    // MARK: - SignUp Method & Firebase
    
    @objc func signUpButtonTapped() {
        print("Sign Up button tapped!")
        
        let registerUserRequest = RegisterUserRequest(
            username: self.usernameField.text ?? "",
            email: self.emailField.text ?? "",
            password: self.passwordField.text ?? ""
        )
        
        if !Validator.isValidUserName(for: registerUserRequest.username) {
            AlertManager.showInvalidUserNameAlert(on: self)
            return
        }
        
        if !Validator.isValidEmail(for: registerUserRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        if !Validator.isValidPassword(for: registerUserRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        print(registerUserRequest)
        
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            
            guard let self = self else {return}
            
            if let error = error {
                AlertManager.showRegistrationErrorAlert(on: self, with: error)
                return
            }
            
            if wasRegistered {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            } else {
                AlertManager.showRegistrationErrorAlert(on: self)
            }
        }
        
    }
    
    
    @objc func googleButtonTapped() {
        print("Google Up button tapped!")
        
    }
    
    
    @objc func signInButtonTapped() {
        
        print("Sign Up Button tapped!")
        let vc = LoginViewController()
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    
}


//#Preview{SignUpViewController()}
