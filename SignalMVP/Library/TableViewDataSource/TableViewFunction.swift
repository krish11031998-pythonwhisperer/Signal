//
//  TableViewFunction.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit

extension NSObject {
	
	static var name: String { "\(self)" }
}

fileprivate extension Array where Self.Element : Equatable {
    
    func findIdx(_ el: Self.Element) -> Int? {
        guard let first = self.enumerated().filter({ $0.element == el }).first else { return nil }
        return first.offset
    }
}

extension UITableView {
	
	private static var propertyKey: UInt8 = 1
	
	private var source: TableViewDataSource? {
		get { return objc_getAssociatedObject(self, &Self.propertyKey) as? TableViewDataSource }
		set { objc_setAssociatedObject(self, &Self.propertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
	
	func registerCell(cell: AnyClass, identifier: String) {
		register(cell, forCellReuseIdentifier: identifier)
	}
	
	func dequeueCell<T: UITableViewCell>(cellIdentifier: String = T.name) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: cellIdentifier) as? T else {
			registerCell(cell: T.self, identifier: cellIdentifier)
			return dequeueReusableCell(withIdentifier: cellIdentifier) as? T ?? T()
		}
		
		return cell
	}
	
	
	func reloadData(_ dataSource: TableViewDataSource, lazyLoad: Bool = false, animation: UITableView.RowAnimation = .none) {
		self.source = dataSource
		
		self.dataSource = dataSource
		self.delegate = dataSource
		
		if let paths = indexPathsForVisibleRows, lazyLoad, dataSource.indexPaths == paths {
			if animation != .none {
				reloadRows(at: paths, with: animation)
			} else {
				paths.forEach { dataSource.tableView(self, updateRowAt: $0) }
			}
		} else {
			reloadData()
		}
	}
	
    func reloadSection(_ section: TableSection, at sectionIdx: Int? = nil) {
        var sections = self.source?.sections ?? []
        guard let idx = sectionIdx ?? sections.findIdx(section) else { return }
        sections[idx] = section
        self.source = .init(sections: sections)
        self.dataSource = source
        self.delegate = source
        reloadSections(.init(integer: idx), with: .automatic)
    }
    
}
