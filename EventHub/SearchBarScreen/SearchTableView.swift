//
//  SearchTableView.swift
//  EventHub
//
//  Created by Валентина Попова on 27.11.2024.
//

import UIKit

protocol SearchTableViewDelegate: AnyObject {
    func didSelectEvent(_ event: Event)
}

class SearchTableView: UITableView {
    
    weak var searchDelegate: SearchTableViewDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
        register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.idTableViewCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .white
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
}
