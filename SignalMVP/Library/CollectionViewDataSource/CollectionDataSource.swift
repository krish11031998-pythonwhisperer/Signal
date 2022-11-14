//
//  CollectionDataSource.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 04/10/2022.
//

import Foundation
import UIKit

class CollectionDataSource: NSObject {
	let sections: [CollectionSection]
	
	init(sections: [CollectionSection]) {
		self.sections = sections
	}
}

extension CollectionDataSource: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		sections[section].cell.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		sections.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		sections[indexPath.section].cell[indexPath.row].collectionView(collectionView, cellForItemAt: indexPath)
	}
}

extension CollectionDataSource: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		sections[indexPath.section].cell[indexPath.row].collectionView(collectionView, didSelectItemAt: indexPath)
	}
}
