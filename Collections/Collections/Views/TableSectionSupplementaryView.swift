//
//  TableSectionSupplementaryView.swift
//  Collections
//
//  Created by Jonathan Benavides Vallejo on 02/07/2018.
//  Copyright © 2018 Jonathan Benavides Vallejo. All rights reserved.
//

import UIKit

class TableSectionSupplementaryView: UIView {
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        
        return label
    }()
    
    
    func update(text: String) {
        textLabel.text = text
    }
}
