//
//  MainViewController.swift
//  Collections
//
//  Created by Jonathan Benavides Vallejo on 01/07/2018.
//  Copyright © 2018 Jonathan Benavides Vallejo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var items: [TableViewItem] = { [unowned self] in
        let first = TableViewItem(title: "Cell Configurator + Generic DataSource") {
            self.navigationController?.pushViewController(CellConfiguratorViewController(), animated: true)
        }
        
        return [first]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        items[indexPath.row].selection()
    }
}
