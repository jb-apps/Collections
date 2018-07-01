//
//  Identifiable.swift
//  Collections
//
//  Created by Jonathan Benavides Vallejo on 01/07/2018.
//  Copyright © 2018 Jonathan Benavides Vallejo. All rights reserved.
//

import UIKit

public protocol Identifiable {
    static var identifier: String { get }
}

extension UITableViewCell: Identifiable {
    public static var identifier: String { return String(describing: self) }
}
