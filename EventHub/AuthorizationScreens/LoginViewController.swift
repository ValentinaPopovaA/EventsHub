//
//  LoginViewController.swift
//  EventHub
//
//  Created by Валентина Попова on 17.11.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let headerView = AuthHeaderView(title: "EventHub", subTitle: "Sign in")
    
    let emailField = UITextField()
    let passwordField = UITextField()
    
    private let rememberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Remember Me"
        return label
    }()
    
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dontLabel: UILabel = {
        let label = UILabel()
        label.text = "Don’t have an account?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = .blue
        toggle.thumbTintColor = .white
        toggle.backgroundColor = .systemGray4
        toggle.layer.cornerRadius = 16
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let forgotButton = CustomButton(title: "Forgot Password?", fontSize: .small)
    private let signUpButton = CustomButton(title: "Sign up", isBlue: true, fontSize: .small)
    
    private let signInButton = UIButton.makePurpleButton(label: "SING IN", target: self, action: #selector(signInButtonTapped))
    
    private let loginGoogleButton = UIButton.makeWhiteButton(label: "Login with Google", target: self, action: #selector(googleButtonTapped))
    
    
    
    
    // MARK: - LifeCycle
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.view.backgroundColor = .systemBackground
        
        self.forgotButton.addTarget(self, action: #selector(forgotButtonTapped), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
  
        emailField.configureTextField(placeholder: "abc@email.com", icon: UIImage(named: "Mail"))
        passwordField.configurePasswordField(placeholder: "Your password")
        
        self.view.addSubview(headerView)
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.headerView.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
            self.headerView.widthAnchor.constraint(equalToConstant: 270)
        ])
        
        
        let stackField = UIStackView(arrangedSubviews: [emailField, passwordField])
        stackField.axis = .vertical
        stackField.spacing = 19
        stackField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackField)
        
        NSLayoutConstraint.activate([
            stackField.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            stackField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        let horizontalStack = UIStackView(arrangedSubviews: [toggleSwitch, rememberLabel, forgotButton])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 30
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: stackField.bottomAnchor, constant: 40),
            horizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            horizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            
        ])
        
        let stackButton = UIStackView(arrangedSubviews: [signInButton, orLabel,  loginGoogleButton])
        stackButton.axis = .vertical
        stackButton.alignment = .center
        stackButton.spacing = 40
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackButton)
        
        NSLayoutConstraint.activate([
            stackButton.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 30),
            stackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let downStack = UIStackView(arrangedSubviews: [dontLabel, signUpButton])
        downStack.axis = .horizontal
        downStack.spacing = 5
        downStack.alignment = .center
        downStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(downStack)
        
        NSLayoutConstraint.activate([
            downStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    
    
    
    //MARK: - Selectors
    
    @objc func signInButtonTapped() {
        print("Sign In button tapped!")
        
        let loginRequest = LoginUserRequest(
            email: self.emailField.text ?? "",
            password: self.passwordField.text ?? ""
        )
        
        
        if !Validator.isValidEmail(for: loginRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        if !Validator.isValidPassword(for: loginRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        AuthService.shared.singIn(with: loginRequest) { error in
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
                
            }
            
        }
    }
    
    @objc func googleButtonTapped() {
        print("Google button tapped!")
        let webView = WebViewerController(with: "https://www.google.ru/")
        let nav = UINavigationController(rootViewController: webView)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func forgotButtonTapped() {
        print("forgotButton tapped!")
        let vc = RessetViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    @objc func signUpButtonTapped() {
        print("Sign Up Button tapped!")
        let vc = SignUpViewController()
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func didTapLogout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else {return }
            if let error = error {
                AlertManager.showLogoutError(on: self, with: error)
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }

}

//#Preview{ LoginViewController()}
