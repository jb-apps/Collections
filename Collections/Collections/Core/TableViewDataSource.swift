import UIKit


/**
 *  DataSourceType
 */
public protocol DataSourceType {
    associatedtype Collection
    
    var title: String? { get }
    var allIndexPaths: [IndexPath] { get }
    
    func configure(with collection: Collection)
    func replace(cellConfigurator: TableViewCellConfiguratorType, at indexPath: IndexPath)
    
    func viewForHeaderInSection(_ section: Int) -> UIView?
    func heightForHeaderInSection(_ section: Int) -> CGFloat
    
    func viewForFooterInSection(_ section: Int) -> UIView?
    func heightForFooterInSection(_ section: Int) -> CGFloat
}

/**
 *  Updatable
 *  Protocol to be implemented by cells for update purpose
 */
public protocol Updatable {
    associatedtype Model
    func update(with model: Model)
}

/**
 *  Selectable
 *  Protocol to be implemented by cells for selection purpose
 */
public protocol Selectable {
    var selection: (TableViewCellConfiguratorType) -> Void { get }
}


/**
 *  TableViewDataSource
 *  Generic Data source implementation
 */
open class TableViewDataSource: NSObject, UITableViewDataSource, DataSourceType {
    
    public var sections: [TableViewDataSourceSection]
    public let title: String?
    public var allIndexPaths: [IndexPath] {
        var indexPaths: [IndexPath] = []
        
        for section in 0..<sections.count {
            for row in 0..<sections[section].count {
                indexPaths.append(IndexPath(item: row, section: section))
            }
        }
        
        return indexPaths
    }
    
    // MARK: - Subscripts
    subscript(indexPath: IndexPath) -> TableViewCellConfiguratorType {
        return sections[indexPath.section][indexPath.row]
    }
    
    subscript(index: Int) -> TableViewDataSourceSection {
        return sections[index]
    }
    
    public init(title: String? = nil, sections: [TableViewDataSourceSection]) {
        self.title = title
        self.sections = sections
    }
    
    public func configure(with collection: UITableView) {
        sections.flatMap { $0.items }.forEach {
            
            if Bundle.main.path(forResource: $0.cellIdentifier, ofType: "nib") != nil {
                // Check if nib exist to register it
                collection.register(UINib(nibName: $0.cellIdentifier, bundle: nil), forCellReuseIdentifier: $0.cellIdentifier)
            } else {
                // Register class
                collection.register($0.cellClass, forCellReuseIdentifier: $0.cellIdentifier)
            }
        }
    }
    
    public func object(at indexPath: IndexPath) -> TableViewCellConfiguratorType {
        return sections[indexPath.section][indexPath.row]
    }
    
    public func replace(cellConfigurator: TableViewCellConfiguratorType, at indexPath: IndexPath) {
        sections[indexPath.section].replace(cellConfigurator: cellConfigurator, at: indexPath.row)
    }
    
    public func viewForHeaderInSection(_ section: Int) -> UIView? {
        guard case let .view(element, _)? = sections[section].header else { return nil }
        
        return element
    }
    
    public func heightForHeaderInSection(_ section: Int) -> CGFloat {
        guard case let .view(element, metrics)? = sections[section].header else {
            return CGFloat(Float.leastNormalMagnitude)
        }
        
        switch metrics {
        case let .height(value):
            return value
        case .automatic:
            return element.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        }
    }
    
    public func viewForFooterInSection(_ section: Int) -> UIView? {
        guard case let .view(element, _)? = sections[section].footer else { return nil }
        return element
    }
    
    public func heightForFooterInSection(_ section: Int) -> CGFloat {
        guard case let .view(element, metrics)? = sections[section].footer else {
            return CGFloat(Float.leastNormalMagnitude)
        }
        
        switch metrics {
        case let .height(value):
            return value
        case .automatic:
            return element.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        }
    }
    
    // MARK: - TableViewDataSource methods
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard case let .string(text)? = sections[section].header else { return nil }
        
        return text
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard case let .string(text)? = sections[section].footer else { return nil }
        
        return text
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellConfigurator = sections[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConfigurator.cellIdentifier, for: indexPath)
        
        cellConfigurator.update(cell: cell)
        
        return cell
    }
    
    deinit {
        let name = String(describing: type(of: self))
        if let title = title {
            debugPrint("\(name) - \(#function) - \(title)")
        } else {
            debugPrint("\(name) - \(#function)")
        }
    }
}


// MARK: - DataSource section
public enum TableViewDataSourceSectionSupplementaryItemMetrics {
    case height(CGFloat)
    case automatic
}

public enum TableViewDataSourceSectionSupplementaryItem {
    case string(String)
    case view(element: UIView, metrics: TableViewDataSourceSectionSupplementaryItemMetrics)
}

/**
 *  TableViewDataSourceSection
 *  Generic Data source section
 */
public struct TableViewDataSourceSection {
    public var items: [TableViewCellConfiguratorType]
    public var header: TableViewDataSourceSectionSupplementaryItem? = nil
    public var footer: TableViewDataSourceSectionSupplementaryItem? = nil
    
    public init (header: TableViewDataSourceSectionSupplementaryItem?,
                 footer: TableViewDataSourceSectionSupplementaryItem?,
                 items: [TableViewCellConfiguratorType]) {
        self.items = items
        self.header = header
        self.footer = footer
    }
    
    public var count: Int {
        return items.count
    }
    
    subscript(index: Int) -> TableViewCellConfiguratorType {
        return items[index]
    }
    
    mutating func replace(cellConfigurator: TableViewCellConfiguratorType, at index: Int) {
        items[index] = cellConfigurator
    }
}

extension TableViewDataSourceSection {
    public init(items: [TableViewCellConfiguratorType]) {
        self.items = items
    }
    
    public init(header: TableViewDataSourceSectionSupplementaryItem, items: [TableViewCellConfiguratorType]) {
        self.items = items
        self.header = header
    }
    
    public init(footer: TableViewDataSourceSectionSupplementaryItem, items: [TableViewCellConfiguratorType]) {
        self.items = items
        self.footer = footer
    }
}


// MARK: - Cell configurators
/**
 * Cell configurators
 */
public protocol TableViewCellConfiguratorType {
    var isSelectable: Bool { get }
    var cellClass: AnyClass { get }
    var cellIdentifier: String { get }
    
    func update(cell: UITableViewCell)
    func didSelectCell()
}

public struct TableViewCellConfigurator<Cell: Updatable & UITableViewCell>: TableViewCellConfiguratorType {
    public var isSelectable: Bool {
        return onSelection != nil
    }
    
    public let model: Cell.Model
    public let cellClass: AnyClass = Cell.self
    public let cellIdentifier: String =  String(describing: Cell.self)
    public var onSelection: ((TableViewCellConfigurator) -> Swift.Void)? = nil
    
    public init(model: Cell.Model) {
        self.model = model
    }
    
    public func update(cell: UITableViewCell) {
        guard let _cell = cell as? Cell else {
            fatalError("Cannot cast :\(String(describing: type(of: cell))) to \(String(describing: type(of: Cell.self)))")
        }
        
        _cell.update(with: model)
    }
    
    func with(_ selection: @escaping (TableViewCellConfigurator) -> Swift.Void) -> TableViewCellConfigurator<Cell> {
        
        var configurator = TableViewCellConfigurator<Cell>(model: model)
        configurator.onSelection = selection
        
        return configurator
    }
    
    public func didSelectCell() {
        onSelection?(self)
    }
}
