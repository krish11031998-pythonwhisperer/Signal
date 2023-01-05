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
	
    func dequeueCell<T: ConfigurableCell>(cellIdentifier: String = T.cellName ?? T.name) -> T {
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
    
    func reloadRows(_ dataSource: TableViewDataSource, section: Int) {
        self.source = dataSource
        self.dataSource = dataSource
        self.delegate = dataSource
        
        let currentRows = numberOfRows(inSection: section)
        let newRows = dataSource.tableView(self, numberOfRowsInSection: section)
    
        guard currentRows < newRows else {
            replaceRows(rows: dataSource.sections[section].rows, section: section)
            return
        }
        let newIndexPath: [IndexPath] = (currentRows..<newRows).map { .init(row: $0, section: section) }
        
        let offset = self.contentOffset
        
        UIView.performWithoutAnimation {
            beginUpdates()
            insertRows(at: newIndexPath, with: .automatic)
            setContentOffset(offset, animated: false)
            endUpdates()
        }
    }
    
    func replaceRows(rows:[TableCellProvider], section: Int) {
        var newSource = self.source
        newSource?.sections[section].rows = rows
        
        self.source = newSource
        self.dataSource = newSource
        self.delegate = newSource
        
        let currentRows = (0..<numberOfRows(inSection: section)).map { IndexPath(row: $0, section: section) }
        
        let newRows = (0..<(source?.tableView(self, numberOfRowsInSection: section) ?? 1)).map { IndexPath(row: $0, section: section) }

        let offset = self.contentOffset
        
        UIView.performWithoutAnimation {
            beginUpdates()
            deleteRows(at: currentRows, with: .right)
            insertRows(at: newRows, with: .left)
            setContentOffset(offset, animated: false)
            endUpdates()
        }
    }
	
    func insertSection(_ section: TableSection, at sectionIdx: Int? = nil) {
        var sections = self.source?.sections ?? []
        let idx = sectionIdx ?? sections.count
        sections.append(section)
        self.source = .init(sections: sections)
        self.dataSource = source
        self.delegate = source
        beginUpdates()
        insertSections([idx], with: .fade)
        endUpdates()
    }
    
    func reloadSection(_ section: TableSection, at sectionIdx: Int? = nil) {
        var sections = self.source?.sections ?? []
        let idx = sectionIdx ?? sections.count
        sections.append(section)
        self.source = .init(sections: sections)
        self.dataSource = source
        self.delegate = source
        beginUpdates()
        let toUpdateIndexSet = IndexSet(integersIn: 1 ..< numberOfSections)
        reloadSections(toUpdateIndexSet, with: .automatic)
        insertSections([idx], with: .right)
        endUpdates()
    }
    
}
