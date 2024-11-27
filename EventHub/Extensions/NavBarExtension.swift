//
//  NavBarExtension.swift
//  EventHub
//
//  Created by Максим on 27.11.2024.
//


import UIKit

// бар навигации как на экранах Sign up и Search
extension UIViewController {
    
    func configurateNavigationBar(
        title: String,
        backImage: UIImage? = UIImage(named: "arrow-left"),
        backAction: Selector? = nil,
        titleFont: UIFont = UIFont.systemFont(ofSize: 24, weight: .bold),
        titleColor: UIColor = .black,
        backgroundColor: UIColor = .systemBackground
    ) {
        
        self.title = title
        
        if let backImage = backImage, let backAction = backAction {
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: backAction)
            backButton.tintColor = .black
            navigationItem.leftBarButtonItem = backButton
        }

        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
               
    }
 
    
}
