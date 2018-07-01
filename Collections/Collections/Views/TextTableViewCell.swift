//
//  TextTableViewCell.swift
//  UtilitiesLibrary_Example
//
//  Created by Jonathan Benavides Vallejo on 29/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

extension TextTableViewCell: Updatable {
    func update(with model: TextModel) {
        titleLabel.text = model.text
    }
}
