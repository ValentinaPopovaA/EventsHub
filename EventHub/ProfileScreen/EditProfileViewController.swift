//
//  EditProfileViewController.swift
//  EventHub
//
//

import UIKit

class EditProfileViewController: UIViewController {
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
    private lazy var nameLabel: UILabel = UILabel.makeCustomLabel(
        text: "Ashfak Sayem",
        font: .systemFont(ofSize: 24, weight: .regular),
        textColor: .black,
        numberOfLines: 1,
        textAligment: .center
    )
    private lazy var editNameButton: UIButton  = {
        let element = UIButton(type: .system)
        element.setImage(UIImage(named: "Edit"), for: .normal)
        element.tintColor = .primaryBlue
        element.addTarget(self, action: #selector(editNameTapped), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var aboutMeLabel: UILabel = UILabel.makeCustomLabelBold(
        text: "About me",
        fontSize: 18,
        textColor: .black,
        numberOfLines: 1,
        textAligment: .left
    )
    
    private lazy var editAboutMeButton: UIButton  = {
        let element = UIButton(type: .system)
        element.setImage(UIImage(named: "Edit"), for: .normal)
        element.tintColor = .primaryBlue
        element.addTarget(self, action: #selector(editAboutMeTapped), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var aboutMeTextView: UITextView  = {
        let element = UITextView()
        element.isScrollEnabled = false
        element.backgroundColor = .clear
        element.font = .systemFont(ofSize: 16)
        element.isEditable = false
        element.textContainerInset = .zero
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
        //        element.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        return element
    }()
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserData()
        
        
    }
    //MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(editNameButton)
        view.addSubview(aboutMeLabel)
        view.addSubview(editAboutMeButton)
        view.addSubview(aboutMeTextView)
        view.addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            editNameButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            editNameButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 18),
            
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 50),
            aboutMeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24),
            aboutMeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -275),
            
            editAboutMeButton.centerYAnchor.constraint(equalTo: aboutMeLabel.centerYAnchor),
            editAboutMeButton.leadingAnchor.constraint(equalTo: aboutMeLabel.trailingAnchor, constant: -8),
            
            aboutMeTextView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 19),
            aboutMeTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19.5),
            aboutMeTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            signOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -135),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func loadUserData() {
        let defaults = UserDefaults.standard
        
        AuthService.shared.fetchUserName { [weak self] username in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.nameLabel.text = username ?? "Алёша"
            }
        }
//        nameLabel.text = /*defaults.string(forKey: "userName") ?? "Your name"*/
        aboutMeTextView.text = defaults.string(forKey: "userAbout") ?? "Enjoy your favorite dish and a lovely time with your friends and family and have a great time. Food from local food trucks will be available for purchase"

    }
    
    @objc private func editNameTapped() {
        let alert = UIAlertController(title: "Edit Name", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.nameLabel.text
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            
            if let newName = alert.textFields?.first?.text {
                if !newName .isEmpty {
                    self.nameLabel.text = newName
                    
                    
                    AuthService.shared.updateUserNameForFB(newUsername: newName) { success, error in
                        if success {
                            print("Имя успешно обновлено!")
                        } else if let error = error {
                            print("Ошибка обновления имени: \(error.localizedDescription)")
                        }
                    }
//                    UserDefaults.standard.set(newName, forKey: "userName")
                }
                
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
        
        
    }
    
    @objc private func editAboutMeTapped() {
        let alert = UIAlertController(title: "Edit About Me", message: nil, preferredStyle: .alert)
   
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
      
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = aboutMeTextView.text
        textView.font = .systemFont(ofSize: 15)
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
     
        containerView.addSubview(textView)
        
   
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: containerView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            textView.heightAnchor.constraint(equalToConstant: 100)
        ])
       
        let viewController = UIViewController()
        viewController.view.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        
        viewController.preferredContentSize = CGSize(width: 300, height: 120)
        alert.setValue(viewController, forKey: "contentViewController")
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let newAbout = textView.text, !newAbout.isEmpty else { return }
            self?.aboutMeTextView.text = newAbout
            UserDefaults.standard.set(newAbout, forKey: "userAbout")
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true) {
            textView.becomeFirstResponder()
        }
    }
    
    
}
