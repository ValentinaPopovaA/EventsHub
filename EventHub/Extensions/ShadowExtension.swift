//
//  ShadowExtension.swift
//  EventHub
//
//  Created by Максим on 21.11.2024.
//

import UIKit


extension UIView {
    
    func dropShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.clipsToBounds = false
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 20
    }
}
