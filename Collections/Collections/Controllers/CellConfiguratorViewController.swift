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
        let tableView = UITableView(frame: .zero, style: .grouped)
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
        /*
            Simple cell sections with custom automatic section header height
         */
        let simpleTextSectionHeaderView = TableSectionSupplementaryView()
        simpleTextSectionHeaderView.update(text: "Simple Text Section header with automatic height")
        simpleTextSectionHeaderView.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        
        let simpleTextSection = TableViewDataSourceSection(
            header: .view(element: simpleTextSectionHeaderView, metrics: .automatic),
            items: [
                TableViewCellConfigurator<TextTableViewCell>(model: TextModel(text: "First text")).with(self.didSelectFirstTextCell),
                TableViewCellConfigurator<TextTableViewCell>(model: TextModel(text: "Second text"))
            ])
        
        
        /*
            Key Value cell sections with custom section header height and automatic footer height
         */
        let keyValueSectionHeaderView = TableSectionSupplementaryView()
        keyValueSectionHeaderView.update(text: "Key value Section header with height as 60")
        keyValueSectionHeaderView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        
        let keyValueSectionFooterView = TableSectionSupplementaryView()
        keyValueSectionFooterView.update(text: "Key value Section footer")
        keyValueSectionFooterView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        
        let keyValueSection = TableViewDataSourceSection(
            header: .view(element: keyValueSectionHeaderView, metrics: .height(60)),
            footer: .view(element: keyValueSectionFooterView, metrics: .automatic),
            items: [
            TableViewCellConfigurator<KeyValueTableViewCell>(model: KeyValue(key: "First Key", value: "First Value")).with(didSelectKeyValueCell),
            TableViewCellConfigurator<KeyValueTableViewCell>(model: KeyValue(key: "Second Key", value: "Second Value")).with(didSelectKeyValueCell)
            ])
        
        
        
        /*
            Mixed cell configurators
         */
        let mixedKeyValueSectionHeaderView = TableSectionSupplementaryView()
        mixedKeyValueSectionHeaderView.update(text: "Mixed Section header")
        mixedKeyValueSectionHeaderView.backgroundColor = UIColor.purple.withAlphaComponent(0.3)
        
        let mixedKeyValueSectionFooterView = TableSectionSupplementaryView()
        mixedKeyValueSectionFooterView.update(text: "Mixed Section footer")
        mixedKeyValueSectionFooterView.backgroundColor = UIColor.purple.withAlphaComponent(0.3)
        
        let mixedKeyValueSection = TableViewDataSourceSection(
            header: .view(element: mixedKeyValueSectionHeaderView, metrics: .automatic),
            footer: .view(element: mixedKeyValueSectionFooterView, metrics: .automatic),
            items: [
                TableViewCellConfigurator<TextTableViewCell>(model: TextModel(text: "First text")).with(self.didSelectFirstTextCell),
                TableViewCellConfigurator<KeyValueTableViewCell>(model: KeyValue(key: "First Key", value: "First Value")),
                TableViewCellConfigurator<TextTableViewCell>(model: TextModel(text: "Second text")),
                TableViewCellConfigurator<KeyValueTableViewCell>(model: KeyValue(key: "Second Key", value: "Second Value"))
            ])
        
        return [simpleTextSection, keyValueSection, mixedKeyValueSection]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        dataSource.configure(with: tableView)
        
        tableView.dataSource = dataSource
        
        tableView.reloadData()
    }
    
    // MARK: - Selections
    private func didSelectFirstTextCell(_ cellConfigurator: TableViewCellConfigurator<TextTableViewCell>) {
        dump(cellConfigurator)
    }
    
    private func didSelectKeyValueCell(_ cellConfigurator: TableViewCellConfigurator<KeyValueTableViewCell>) {
        dump(cellConfigurator)
    }
    
    
    deinit {
        debugPrint(#function + " - " + String(describing: type(of: self)))
    }
}

extension CellConfiguratorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSource.viewForHeaderInSection(section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource.heightForHeaderInSection(section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return dataSource.viewForFooterInSection(section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataSource.heightForFooterInSection(section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        dataSource[indexPath].didSelectCell()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return dataSource[indexPath].isSelectable
    }
}
