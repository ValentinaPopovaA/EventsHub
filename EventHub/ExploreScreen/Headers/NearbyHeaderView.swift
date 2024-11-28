//
//  NearbyHeaderView.swift
//  EventHub
//
//  Created by Екатерина Орлова on 28.11.2024.
//

import UIKit

class NearbyHeaderView: UICollectionReusableView {
    
    static let identifire = "NearbyHeader"
    
    var buttonEvent: (() -> Void)?
    
     var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .titleColor
        label.font = .systemFont(ofSize:18 )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "see_all"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped () {
        buttonEvent?()
    }
    func config(headerLabel: String,tapAction: (@escaping () -> Void)) {
        self.headerLabel.text = headerLabel
        self.button.isUserInteractionEnabled = true
        buttonEvent = tapAction
    }
    func setupUI () {
        addSubview(headerLabel)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            button.topAnchor.constraint(equalTo: topAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}