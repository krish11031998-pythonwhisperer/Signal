//
//  CollectionColumn.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 04/10/2022.
//

import Foundation
import UIKit

//MARK: - ConfigurableCollectionCell

typealias ConfigurableCollectionCell = Configurable & UICollectionViewCell

//MARK: - CollectionCellProvider

protocol CollectionCellProvider {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

//MARK: - CollectionItem
class CollectionItem<Cell:ConfigurableCollectionCell>: CollectionCellProvider {
	var model: Cell.Model
	
	init(_ model: Cell.Model) {
		self.model = model
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: Cell = collectionView.dequeueCell(indexPath: indexPath)
		cell.configure(with: model)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		if let action = model as? ActionProvider {
            cell.layer.animate(.bouncy, removeAfterCompletion: true)
			action.action?()
            let cellOrigin = cellFrame(collection: collectionView, cell: cell)
            action.actionWithFrame?(.init(origin: cellOrigin, size: cell.frame.size))
		}
	}
}


//MARK: - CollectionColumn Helpers

extension CollectionItem {
    
    func cellFrame(collection: UICollectionView, cell: UICollectionViewCell) -> CGPoint {
        guard let superView = collection.superview else { return .zero }
        let cellOrigin = cell.convert(superView.frame.origin, to: nil)
        return cellOrigin
    }
    
}
