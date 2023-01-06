//
//  CollectionViewFunctions.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 04/10/2022.
//

import Foundation
import UIKit

extension UICollectionView {
	
	private static var propertyKey: UInt8 = 1
	
	private(set) var source: CollectionDataSource? {
		get { return objc_getAssociatedObject(self, &Self.propertyKey) as? CollectionDataSource }
		set { objc_setAssociatedObject(self, &Self.propertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
	
	func dequeueCell<Cell:UICollectionViewCell>(_ name: String = Cell.name, indexPath: IndexPath) -> Cell {
		self.register(Cell.self, forCellWithReuseIdentifier: Cell.name)
		guard let cell = try? dequeueReusableCell(withReuseIdentifier: Cell.name, for: indexPath) as? Cell else {
			return dequeueReusableCell(withReuseIdentifier: Cell.name, for: indexPath) as? Cell ?? Cell()
		}
		return cell
	}
	
	
	func reloadData(_ dataSource: CollectionDataSource) {
		self.source = dataSource
		self.dataSource = dataSource
		self.delegate = dataSource
		self.reloadData()
	}
}
