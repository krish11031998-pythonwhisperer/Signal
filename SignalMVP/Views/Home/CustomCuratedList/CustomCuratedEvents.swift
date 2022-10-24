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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
       
        setupCollection()
        
        let card = viewStack.embedInView(insets: .init(vertical: 12.5, horizontal: 10))
        card.backgroundColor = .surfaceBackgroundInverse
        card.clippedCornerRadius = 12
        contentView.addSubview(card)
        contentView.setFittingConstraints(childView: card, insets: .init(vertical: 5, horizontal: 10))
        
        "Your Radar Letter".heading3(color: .textColorInverse).render(target: label)
        contentView.backgroundColor = .surfaceBackground
    }
    
    private func setupCollection() {
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.setHeight(height: layout.itemSize.height, priority: .required)
        collection.backgroundColor = .surfaceBackgroundInverse
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
    }
    
    func configure(with model: EmptyModel) {
        
    }
}

//MARK: - CustomCuratedEvents: UICollectionDataSource

extension CustomCuratedEvents: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { numberOfItems }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .surfaceBackground.withAlphaComponent(0.25)
        cell.clippedCornerRadius = 12
        cell.contentView.removeChildViews()
        let label = "\(indexPath.row + 1)".body1Medium().generateLabel
        cell.contentView.addSubview(label)
        label.textAlignment = .center
        cell.contentView.setFittingConstraints(childView: label, insets: .zero)
        
        return cell
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
    
}
