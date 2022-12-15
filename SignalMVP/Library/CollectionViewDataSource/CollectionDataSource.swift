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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        sections[indexPath.section].cell[indexPath.row].collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        sections[indexPath.section].cell[indexPath.row].collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
}

extension CollectionDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.cellForItem(at: indexPath)
        let size = (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? cell?.compressedSize ?? .zero
        return size
        
    }
}
