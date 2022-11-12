//
//  CustomCuratedEvents.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/10/2022.
//

import Foundation
import UIKit

struct EmptyModel {}

//MARK: - CustomCuratedEvents

class CustomCuratedEvents: ConfigurableCell {
    
    private lazy var label: UILabel = { .init() }()
    private let itemSize: CGSize = { .init(width: 250, height: 300) }()
    private let numberOfItems: Int = 10
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 10
        return layout
    }()
    private lazy var collection: UICollectionView = { .init(frame: .zero, collectionViewLayout: layout) }()
    private lazy var viewStack: UIStackView = { .VStack(subViews:[label, collection] ,spacing: 10) }()
    private var contentOffsetObserver: NSKeyValueObservation?
    private var headlines: [TrendingHeadlinesModel] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
       
        setupCollection()
        contentView.addSubview(viewStack)
        contentView.setFittingConstraints(childView: viewStack, insets: .init(vertical: 5, horizontal: 10))
        
        "Your Radar Letter".heading3(color: .textColor).render(target: label)
        contentView.backgroundColor = .surfaceBackground
    }
    
    private func setupCollection() {
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.setHeight(height: layout.itemSize.height, priority: .required)
        collection.backgroundColor = .surfaceBackground
        collection.showsHorizontalScrollIndicator = false
    }
    
    private func reloadCollection() {
        collection.reloadData(buildDataSource())
        collection.delegate = self
    }
    
    private var headlineSection: CollectionSection {
        .init(cell: headlines.compactMap { CollectionItem<CustomCuratedCell>($0) })
    }
    
    private func buildDataSource() -> CollectionDataSource {
        .init(sections: [headlineSection])
    }
    
    private func scrollUpdate(scrollView: UIScrollView) {
        guard scrollView.contentOffset != .zero else { return }
        let cellIdx = (scrollView.contentOffset.x/itemSize.width).rounded(.up)
        print("(DEBUG) cellIdx : ", cellIdx)
        guard cellIdx > 0 , Int(cellIdx) < numberOfItems - 1 else { return }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            scrollView.contentOffset.x = (cellIdx - 1) * self.itemSize.width + (cellIdx - 1) * self.layout.minimumInteritemSpacing
        }
    }
    
    func configure(with model: [TrendingHeadlinesModel]) {
        headlines = model
        reloadCollection()
    }
}

//MARK: - CustomCuratedEvents: UICollectionDelegate

extension CustomCuratedEvents: UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cellIdx = (scrollView.contentOffset.x/itemSize.width).rounded(.up)
        print("(DEBUG) cellIdx : ", cellIdx)
        guard cellIdx > 0 , Int(cellIdx) < numberOfItems - 1 else { return }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            scrollView.contentOffset.x = (cellIdx - 1) * self.itemSize.width + (cellIdx - 1) * self.layout.minimumInteritemSpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.source?.collectionView(collectionView, didSelectItemAt: indexPath)
    }

}
