//
//  ViewExtension.swift
//  EventHub
//
//  Created by Максим on 19.11.2024.
//

import UIKit

extension UITextField {
    
    func configureTextField(placeholder: String, icon: UIImage?) {
        self.placeholder = placeholder
        self.font = UIFont.systemFont(ofSize: 16)
        self.layer.cornerRadius = 15
        self.heightAnchor.constraint(equalToConstant: 56).isActive = true
        self.backgroundColor = .white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayForDetail.cgColor
        
        self.textColor = UIColor.black
        
        if let icon = icon {
            let iconView = UIImageView(image: icon)
            iconView.contentMode = .center
            iconView.tintColor = UIColor.systemGray
            
            let padding: CGFloat = 10
            let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: icon.size.width + padding + padding, height: icon.size.height))
            iconContainerView.addSubview(iconView)
            iconView.frame = CGRect(x: padding, y: 0, width: icon.size.width, height: icon.size.height)
            
            self.leftView = iconContainerView
            self.leftViewMode = .always
        }
    }
    
    func configurePasswordField(placeholder: String) {
        configureTextField(placeholder: placeholder, icon: UIImage(named: "Lock"))
        self.isSecureTextEntry = true
        self.textContentType = .newPassword
        
        let showPasswordButton = UIButton(type: .custom)
        showPasswordButton.setImage(UIImage(named: "Hidden"), for: .normal)
        showPasswordButton.tintColor = UIColor.systemGray
        
        let padding: CGFloat = 10
        
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 24 + padding, height: 24)
        showPasswordButton.tintColor = UIColor.systemGray
        let iconContainerView = UIView(frame: CGRect(x: padding, y: 0, width: showPasswordButton.frame.width + padding, height: showPasswordButton.frame.height))
        iconContainerView.addSubview(showPasswordButton)
        iconContainerView.bringSubviewToFront(showPasswordButton)
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)

        self.rightView = iconContainerView
        self.rightViewMode = .always
        
        
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        guard let container = sender.superview,
              let textField = container.superview as? UITextField else { return }
        textField.isSecureTextEntry.toggle()
        let buttonImage = textField.isSecureTextEntry ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
        sender.setImage(buttonImage, for: .normal)
    }
    
    
    
}
