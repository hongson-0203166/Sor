//
//  Extension+Tableview.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 29/09/2024.
//

import UIKit

extension UITableView {
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }
    
    func registerCell(name: String) {
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    func registerCell<T: UITableViewCell>(_ name: T.Type) {
        register(UINib(nibName: String(describing: name), bundle: nil), forCellReuseIdentifier: String(describing: name))
    }
    
    func registerNibHeaderFooterFor<T: UIView>(type: T.Type) {
        let nibName = type.name
        register(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    func dequeueCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(with type: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: type.interfaceId) as! T
    }
    
    func scrollToBottom(list: [Any], animated: Bool = false) {
        if !list.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                self.scrollToRow(at: IndexPath(row: list.count - 1, section: 0), at: .bottom, animated: animated)
            })
        }
    }
    
    func scrollToTop() {
        if !self.visibleCells.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
        }
    }
    
    func setHeightForFooter(_ height: CGFloat = 0) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: height))
        view.backgroundColor = .clear
        tableFooterView = view
    }
    
    func setHeightForHeader(_ height: CGFloat = 0) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: height))
        view.backgroundColor = .clear
        tableHeaderView = view
    }
}

extension UITableViewCell {
    static var name: String {
        return String(describing: self)
    }
}

// MARK: Methods
extension UITableViewCell {
    static var cellName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
    
    static var nibName: String {
        return cellName
    }
    
    static var reuseIdentifier: String {
        return cellName
    }
}


protocol InterfaceRepresentable {
    static var interfaceId: String { get }
    static var nib: UINib { get }
    var interfaceId: String { get }
}

extension InterfaceRepresentable {
    static var interfaceId: String { return String(describing: self) }
    
    static var nib: UINib {
        return UINib(nibName: interfaceId, bundle: nil)
    }
    
    var interfaceId: String {
        return String(describing: type(of: self))
    }
}

extension UIView: InterfaceRepresentable { }
extension UIViewController: InterfaceRepresentable { }
