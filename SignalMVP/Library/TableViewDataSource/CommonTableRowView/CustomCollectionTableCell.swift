//
//  CustomCollectionTableCell.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 04/10/2022.
//

import Foundation
import UIKit

struct CollectionTableCellModel {
	let cells: [CollectionCellProvider]
	let size: CGSize
	let inset: UIEdgeInsets
	let isPagingEnabled: Bool
	let cellSize: CGSize
	let automaticDimension: Bool
	let interspacing: CGFloat
	init(cells: [CollectionCellProvider],
		 size: CGSize? = nil,
		 inset: UIEdgeInsets = .init(vertical: 0, horizontal: 8),
		 cellSize: CGSize,
		 automaticDimension: Bool = false,
		 interspacing: CGFloat = 10,
		 isPagingEnabled: Bool = false) {
		self.cells = cells
		self.size = size ?? .init(width: .totalWidth, height: cellSize.height)
		self.inset = inset
		self.cellSize = cellSize
		self.isPagingEnabled = isPagingEnabled
		self.interspacing = interspacing
		self.automaticDimension = automaticDimension
		
	}
}



class CollectionTableCell: ConfigurableCell {

	private lazy var collection: UICollectionView = {
		let collection: UICollectionView = .init(frame: .zero, collectionViewLayout: .init())
		collection.showsVerticalScrollIndicator = false
		collection.showsHorizontalScrollIndicator = false
		return collection
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupViews()
	}
	
	private func layout(size: CGSize,
						interSpacing: CGFloat,
						inset: UIEdgeInsets,
						automaticSize: Bool) -> UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumInteritemSpacing = 10
		if automaticSize {
			layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		} else {
			layout.itemSize = size
		}
		layout.sectionInset = inset
		return layout
	}
	
	private func setupViews() {
		backgroundColor = .surfaceBackground
		selectionStyle = .none
		collection.backgroundColor = .surfaceBackground
		contentView.addSubview(collection)
		contentView.setFittingConstraints(childView: collection, insets: .zero)
	}
	
	func configure(with model: CollectionTableCellModel) {
		collection.setFrame(model.size)
		collection.collectionViewLayout = layout(size: model.cellSize, interSpacing: model.interspacing, inset: model.inset, automaticSize: model.automaticDimension)
        collection.reloadData(.init(sections: [.init(cell: model.cells)]))
	}

	static var cellName: String? {
		let name = UUID().uuidString
		return "CollectionTableCell.\(name)"
	}
}
