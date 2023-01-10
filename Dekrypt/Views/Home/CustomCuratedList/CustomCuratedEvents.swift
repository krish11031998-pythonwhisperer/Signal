//
//  CustomCuratedEvents.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/10/2022.
//

import Foundation
import UIKit
import Combine

struct EmptyModel {}
struct CuratedEventModel {
    let events: [EventModel]
    let selectedEvent: PassthroughSubject<EventModel?, Never>
}
//MARK: - CustomCuratedEvents

class CustomCuratedEvents: ConfigurableCell {
    
    private let itemSize: CGSize = { .init(width: .totalWidth * 0.5, height: 225) }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 10
        return layout
    }()
    private lazy var collection: UICollectionView = { .init(frame: .zero, collectionViewLayout: layout) }()
    private var contentOffsetObserver: NSKeyValueObservation?
    private var eventsModel: CuratedEventModel?
    private var endScroll: PassthroughSubject<Bool, Never> = .init()
    private var currentContentOffset: CGFloat = -1
    private var bag: Set<AnyCancellable> = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        setupCollection()
        contentView.addSubview(collection)
        contentView.setFittingConstraints(childView: collection, insets: .zero)
        contentView.backgroundColor = .surfaceBackground
    }
    
    private func setupCollection() {
        collection.contentInset = .init(vertical: 5, horizontal: 10)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.setHeight(height: layout.itemSize.height + 10, priority: .required)
        collection.backgroundColor = .surfaceBackground
        collection.showsHorizontalScrollIndicator = false
    }

    private var headlineSection: CollectionSection? {
        guard let events = eventsModel?.events.limitTo(to: 5) else { return nil }
        return .init(cell: events.compactMap { event in
            var model = EventCellModel(model: event)
            model.action = { [weak self] in
                self?.eventsModel?.selectedEvent.send(event)
            }
            return CollectionItem<CustomCuratedCell>(model)
        })
    }
    
    private func buildDataSource() -> CollectionDataSource {
        .init(sections: [headlineSection].compactMap { $0 })
    }
    
    func configure(with model: CuratedEventModel) {
        eventsModel = model
        collection.reloadData(buildDataSource())
    }
}
