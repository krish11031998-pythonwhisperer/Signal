//
//  VideoScreen.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/11/2022.
//

import Foundation
import UIKit
import Combine

class VideoViewController: UIViewController {
    
    private var videos: [VideoModel] = []
    private var viewModel: VideoViewModel
    private var bag: Set<AnyCancellable> = .init()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel = .init()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = .init()
        fatalError("init(coder:) has not been implemented")
    }
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
    
    private func loadVideos() {
        self.viewModel.videos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] collectionSection in
                self?.collection.reloadData(.init(sections: [collectionSection]))
            }
            .store(in: &bag)
    }
}
