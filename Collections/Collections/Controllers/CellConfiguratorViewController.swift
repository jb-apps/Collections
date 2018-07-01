//
//  CellConfiguratorViewController.swift
//  Collections
//
//  Created by Jonathan Benavides Vallejo on 01/07/2018.
//  Copyright © 2018 Jonathan Benavides Vallejo. All rights reserved.
//

import UIKit

class CellConfiguratorViewController: UIViewController {
    
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        return tableView
    }()

    lazy var dataSource: TableViewDataSource = TableViewDataSource(sections: self.dataSourceSections)
    
    lazy var dataSourceSections: [TableViewDataSourceSection] = { [unowned self] in
        let simpleTextSection = TableViewDataSourceSection(
            header: .string("Simple Text Section header"),
            footer: .string("Simple Text Section Footer"),
            items: [
                TableViewCellConfigurator<TextTableViewCell>(model: TextModel(text: "First text")).with(self.didSelectFirstText),
                TableViewCellConfigurator<TextTableViewCell>(model: TextModel(text: "Second text"))
            ])
        
        
        let keyValueSection = TableViewDataSourceSection(items: [
            TableViewCellConfigurator<KeyValueTableViewCell>(model: KeyValue(key: "First Key", value: "First Value")),
            TableViewCellConfigurator<KeyValueTableViewCell>(model: KeyValue(key: "Second Key", value: "Second Value"))
            ])
        
        return [simpleTextSection, keyValueSection]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        dataSource.configure(with: tableView)
        
        tableView.dataSource = dataSource
        
        tableView.reloadData()
    }
    
    // MARK: - Selections
    private func didSelectFirstText() {
        debugPrint(#function)
    }
    
    
    deinit {
        debugPrint(#function + " - " + String(describing: type(of: self)))
    }
}

extension CellConfiguratorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        dataSource[indexPath].didSelectCell()
    }
}
