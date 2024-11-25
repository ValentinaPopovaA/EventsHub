//
//  UIButton+Ext.swift
//  EventHub
//
//  Created by Валентина Попова on 18.11.2024.
//

import UIKit

extension UIButton {
    static func makePurpleButton(label: String,
                                 target: Any?,
                                 action: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .primaryBlue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(named: "Forward"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(label, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -11),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            
            button.titleLabel!.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            button.titleLabel!.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 271),
            button.heightAnchor.constraint(equalToConstant: 58)
        ])
        
        button.addTarget(target, action: action, for: .touchUpInside)
        button.addTarget(button, action: #selector(buttonTouchedDown), for: .touchDown)
        
        return button
    }
    
    
    static func makeWhiteButton(label: String,
                                target: Any?,
                                action: Selector) -> UIButton {
        
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let containerStackView = UIStackView()
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.spacing = 10
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(named: "super_g"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = label
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.isUserInteractionEnabled = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(titleLabel)
        
        button.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            button.widthAnchor.constraint(equalToConstant: 273),
            button.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        button.addTarget(target, action: action, for: .touchUpInside)
        button.addTarget(button, action: #selector(buttonTouchedDown), for: .touchDown)
        
        button.dropShadow()
        
        return button
    }
    
    
    @objc private func buttonTouchedDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 0.1) {
                sender.alpha = 1.0
            }
        }
    }
    
    static func makeCustomButtonForShareScreen(image:String, subtitle: String, action: Selector, top: CGFloat = 5) -> UIButton {
        let button = UIButton()
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: image)
        configuration.imagePlacement = .top
        configuration.subtitle = subtitle
        configuration.baseForegroundColor = .titleColor
        configuration.contentInsets = .init(top: top, leading: 0, bottom: 0, trailing: 0)
        button.configuration = configuration
        button.addTarget(nil, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
