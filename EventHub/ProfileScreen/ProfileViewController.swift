//
//  ProfileViewController.swift
//  EventHub
//
//  Created by Валентина Попова on 17.11.2024.
//

import UIKit

class ProfileViewController: UIViewController, UITextViewDelegate {
    //MARK: - UI Elements
    private lazy var profileImageView: UIImageView  = {
        let element = UIImageView()
        element.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        element.layer.cornerRadius = 50
        element.clipsToBounds = true
        element.image = UIImage(named: "ava1")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var editProfileButton: UIButton  = {
        let element = UIButton()
        element.backgroundColor = .clear
        element.layer.cornerRadius = 10
        element.layer.borderWidth = 1
        element.layer.borderColor = UIColor.primaryBlue.cgColor
        element.translatesAutoresizingMaskIntoConstraints = false
        element.addSubview(iconImageView)
        element.addSubview(titleLabel)
        element.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
           
        return element
    }()
    
    private lazy var iconImageView: UIImageView  = {
        let element = UIImageView()
        element.image = UIImage(named: "Edit")
        element.contentMode = .scaleAspectFit
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var nameLabel: UILabel = UILabel.makeCustomLabel(
        text: "",
        font: .systemFont(ofSize: 24, weight: .regular),
        textColor: .black,
        numberOfLines: 1,
        textAligment: .center
    )
    
    private lazy var titleLabel: UILabel  = UILabel.makeCustomLabel(
        text: "Edit Profile",
        font: .systemFont(ofSize: 16, weight: .regular),
        textColor: .primaryBlue,
        numberOfLines: 1,
        textAligment: nil
    )
    
    private lazy var aboutMeLabel: UILabel = UILabel.makeCustomLabelBold(
        text: "About me",
        fontSize: 18,
        textColor: .black,
        numberOfLines: 1,
        textAligment: .left
    )
    private lazy var aboutMeTextView: UITextView  = {
        let element = UITextView()
        element.isScrollEnabled = false
        element.backgroundColor = .clear
        element.attributedText = makeAboutMeText()
        element.linkTextAttributes = [
            .foregroundColor: UIColor.primaryBlue
           ]
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var signOutButton: UIButton = {
        let element = UIButton(type: .system)
        element.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.plain()
        config.title = "Sign Out"
        config.baseForegroundColor = .black
        config.image = UIImage(named: "Log_in_outline")
        config.imagePlacement = .leading
        config.imagePadding = 8
        element.configuration = config
        element.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        return element
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        aboutMeTextView.delegate = self
        setupUI()
        updateProfileData()
       
    }
    
    //MARK: - Setup UI
    
    func updateProfileData() {
        
        AuthService.shared.fetchUserName { [weak self] username in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.nameLabel.text = username ?? "Алёша"
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(editProfileButton)
        view.addSubview(aboutMeLabel)
        view.addSubview(aboutMeTextView)
        view.addSubview(signOutButton)
   
        
        NSLayoutConstraint.activate([
//          Profile Image View
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
//          Name Label
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
//          Icon Image View
            iconImageView.leadingAnchor.constraint(equalTo: editProfileButton.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: editProfileButton.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
//           Title Label
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: editProfileButton.centerYAnchor),
            
//          Edit Profile Button
            editProfileButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            editProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editProfileButton.widthAnchor.constraint(equalToConstant: 154),
            editProfileButton.heightAnchor.constraint(equalToConstant: 50),
            
//          About Me Label
            aboutMeLabel.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 50),
            aboutMeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24),
            aboutMeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -275),
            
//          About Me Text View
            aboutMeTextView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 19),
            aboutMeTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19.5),
            aboutMeTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
//           Sign Out Button
            signOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -135),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
    }

    @objc private func readMoreButtonTapped() {
    }
    @objc private func editProfileButtonTapped() {

        let editProfileViewController = EditProfileViewController()

        self.present(editProfileViewController, animated: true, completion: nil)
    }

//    @objc private func signOutButtonTapped() {
//    let onboardingViewController = OnboardingViewController()
//    self.present(onboardingViewController, animated: true, completion: nil)
//  
//    }
    
    @objc private func signOutButtonTapped() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else {return }
            if let error = error {
                
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard URL.absoluteString == "readMoreAction" else {
            return true
        }
        readMoreButtonTapped()
        return false
    }
    
    private func makeAboutMeText() -> NSAttributedString {
        let text = "Enjoy your favorite dish and a lovely time with your friends and family and have a great time. Food from local food trucks will be available for purchase. "
        let readMoreText = "Read More"
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ])
        let readMoreAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .link: "readMoreAction"
        ]
        let readMoreAttributedString = NSAttributedString(string: readMoreText, attributes: readMoreAttributes)

        attributedString.append(readMoreAttributedString)
        
        
        return attributedString
    }
    
}
