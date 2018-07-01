//
//  KeyValueTableViewCell.swift
//  UtilitiesLibrary_Example
//
//  Created by Jonathan Benavides Vallejo on 29/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class KeyValueTableViewCell: UITableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}

extension KeyValueTableViewCell: Updatable {
    func update(with keyValue: KeyValue<String, String>) {
        keyLabel.text = keyValue.key
        valueLabel.text = keyValue.value
    }
}
