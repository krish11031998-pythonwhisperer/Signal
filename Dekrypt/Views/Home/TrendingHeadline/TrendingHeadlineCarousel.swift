//
//  TrendingHeadlineCarousel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 04/01/2023.
//

import Foundation
import UIKit
import Combine

class TrendingHeadlinesCarousel: ConfigurableCell {
    
    private let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: .totalWidth, height: 200)
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .surfaceBackground
        return collection
    }()
    private var bag: Set<AnyCancellable> = .init()
    private var headlines: [TrendingHeadlinesModel] = []
    private var animateScroll: CADisplayLink?  {
        willSet {
            if newValue == nil {
                animateScroll?.invalidate()
            }
        }
        
        didSet {
            animateScroll?.preferredFramesPerSecond = 30
            animateScroll?.add(to: RunLoop.current, forMode: .common)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        animateScroll = nil
    }
    
    func configure(with model: [TrendingHeadlinesModel]) {
        reloadCollection(headlines: model.limitTo(to: 4))
    }
    
    private func setupView() {
        contentView.addSubview(collection)
        contentView.setFittingConstraints(childView: collection, insets: .zero)
        collection.setFrame(width: .totalWidth, height: 220)
    }
    
    private func reloadCollection(headlines: [TrendingHeadlinesModel]) {
        self.headlines = headlines
        let cells = headlines.compactMap {
            CollectionItem<TrendingHeadlineCollectionCell>($0)
        }
        collection.reloadData(.init(sections: [.init(cell: cells)]))
        if animateScroll == nil {
            animateScroll = .init(target: self, selector: #selector(handleAutoScrollAnimation))
        }
    }
    
    private func bind() {
        collection.publisher(for: \.contentOffset)
            .filter { [weak self] _ in
                guard let self else { return false }
                return self.collection.isDragging || self.collection.isDecelerating
            }
            .sink { [weak self] _ in
                guard let self else { return }
                if self.collection.isDragging {
                    self.animateScroll = nil
                } else if self.collection.isDecelerating {
                    self.animateScroll = .init(target: self, selector: #selector(self.handleAutoScrollAnimation))
                }
            }
            .store(in: &bag)
    }
    
    @objc
    private func handleAutoScrollAnimation() {
        let size = collection.contentSize
        let offset = collection.contentOffset.x
        
        if offset < size.width - .totalWidth {
            self.collection.contentOffset.x += 0.25
        } else {
            let last = headlines.last
            var recurringHeadlines = [last].compactMap { $0 }
            recurringHeadlines.append(contentsOf: headlines[0..<headlines.count - 1])
            reloadCollection(headlines: recurringHeadlines)
            collection.setContentOffset(.zero, animated: false)
        }
    }
    
}
