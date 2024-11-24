//
//  ShareView.swift
//  EventHub
//
//  Created by Екатерина Орлова on 20.11.2024.
//

import UIKit

protocol ShareViewDelegate: AnyObject {
    func dismissOverlay()
}
class ShareView: UIView {
    
    var delegate: ShareViewDelegate?
    let title: UILabel = {
        let label = UILabel()
        label.text = "Share with friends"
        label.textAlignment = .left
        label.font = .systemFont(ofSize:24 , weight: .semibold)
        label.textColor = .titleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let firstView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let linkButton = UIButton.makeCustomButtonForShareScreen(image: "Copy_link", subtitle: "Copy link", action: #selector(buttonsPressed))
    let wtsAppButton = UIButton.makeCustomButtonForShareScreen(image: "WhatsApp", subtitle: "WhatsApp", action: #selector(buttonsPressed))
    let secondView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let facebookButton = UIButton.makeCustomButtonForShareScreen(image: "Facebook", subtitle: "Facebook", action: #selector(buttonsPressed))
    let messengerButton = UIButton.makeCustomButtonForShareScreen(image: "Messenger", subtitle: "Messenger", action: #selector(buttonsPressed))
    let thirdView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let twitterButton = UIButton.makeCustomButtonForShareScreen(image: "Twitter", subtitle: "Twitter", action: #selector(buttonsPressed))
    let instaButton = UIButton.makeCustomButtonForShareScreen(image: "Instagram", subtitle: "Instagram", action: #selector(buttonsPressed))
    
    let fourthView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let skypeButton = UIButton.makeCustomButtonForShareScreen(image: "Skype", subtitle: "Skype", action: #selector(buttonsPressed))
    let messageButton = UIButton.makeCustomButtonForShareScreen(image: "Message", subtitle: "Message", action: #selector(buttonsPressed))
                             
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("CANCEL", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        button.backgroundColor = .greyLight
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(dismissOverlay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        clipsToBounds = true
        layer.cornerRadius = 25
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonsPressed(_ sender: UIButton) {
       print(sender)
    }

       func configUI() {
           addSubview(title)
           addSubview(buttonsStack)
           
           buttonsStack.addArrangedSubview(firstView)
           
           firstView.addArrangedSubview(linkButton)
           firstView.addArrangedSubview(twitterButton)
           
           buttonsStack.addArrangedSubview(secondView)
           secondView.addArrangedSubview(wtsAppButton)
           secondView.addArrangedSubview(instaButton)
               
           buttonsStack.addArrangedSubview(thirdView)
           
           thirdView.addArrangedSubview(facebookButton)
           thirdView.addArrangedSubview(skypeButton)
           
           buttonsStack.addArrangedSubview(fourthView)
           fourthView.addArrangedSubview(messengerButton)
           fourthView.addArrangedSubview(messageButton)
           
           addSubview(cancelButton)
           
           NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            buttonsStack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 18),
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            buttonsStack.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -24),

            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            cancelButton.heightAnchor.constraint(equalToConstant: 58)
           ])
       }
}

private extension ShareView {
    @objc func dismissOverlay() {
        delegate?.dismissOverlay()
    }
}
