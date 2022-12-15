//
//  VideoScreen.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/11/2022.
//

import Foundation
import UIKit

class VideoViewController: UIViewController {
    
    private var videos: [VideoModel] = []
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: .totalWidth, height: .totalHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.isPagingEnabled = true
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadVideos()
        standardNavBar(leftBarButton: .init(customView: "Video".heading2().generateLabel))
        navigationController?.navigationItem.leftBarButtonItem = nil
    }
    
    private func setupView() {
        view.addSubview(collection)
        view.setFittingConstraints(childView: collection, insets: .zero)
        collection.contentInsetAdjustmentBehavior = .never
    }
    
    
    private func loadCollection() {
        collection.reloadData(.init(sections: [videoSection].compactMap { $0 }))
    }
    
    private var videoSection: CollectionSection? {
        guard !videos.isEmpty else { return nil }
        let collectionCells: [CollectionCellProvider] = videos.compactMap {
            return CollectionItem<VideoTikTokCell>($0)
        }
        return .init(cell: collectionCells)
    }
    
    private func loadVideos() {
        StubVideoService.shared.fetchVideo { [weak self] in
            guard let videos = $0.data else { return }
            self?.videos = videos
            DispatchQueue.main.async {
                self?.loadCollection()
            }
        }
    }
}
