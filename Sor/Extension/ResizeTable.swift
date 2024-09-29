//
//  ResizeTable.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 29/09/2024.
//

import UIKit

class AutoReSizeTableView: UITableView {
    override open func awakeFromNib() {
        super.awakeFromNib()
        defaultSetup()
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        defaultSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultSetup()
    }

    func defaultSetup() {
        // Setup mặc định
    }

    /// Chiều cao tối đa
    var maxHeight: CGFloat?

    /// Chiều cao tối thiểu
    var minHeight: CGFloat?

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }

    override var intrinsicContentSize: CGSize {
        let height: CGFloat

        if let maxHeight = maxHeight {
            height = min(contentSize.height, maxHeight)
        } else if let minHeight = minHeight {
            height = max(contentSize.height, minHeight)
        } else {
            height = contentSize.height
        }

        return CGSize(width: contentSize.width, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}


import UIKit

class BaseTBCell: UITableViewCell {

    // MARK: define for cell
    static func identifier() -> String {
        return String(describing: self.self)
    }

    static func height() -> CGFloat {
        return 0
    }

    static func registerCellByClass(_ tableView: UITableView) {
        tableView.register(self.self, forCellReuseIdentifier: self.identifier())
    }

    static func registerCellByNib(_ tableView: UITableView) {
        let nib = UINib(nibName: self.identifier(), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.identifier())
    }

    // swiftlint:disable all
    static func loadCell(_ tableView: UITableView) -> BaseTBCell {
        return tableView.dequeueReusableCell(withIdentifier: self.identifier()) as! BaseTBCell
    }
    // swiftlint:enable all
}

class BaseTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
