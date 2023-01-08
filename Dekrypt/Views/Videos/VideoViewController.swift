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
        startLoadingAnimation()
        bind()
        
        standardNavBar(leftBarButton: .init(customView: "Video".heading2(color: view.userInterface == .dark ? .textColor : .textColorInverse).generateLabel), color: .clear, scrollColor: .clear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.view.overrideUserInterfaceStyle = .dark
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.tabBarController?.view.overrideUserInterfaceStyle = view.userInterface
    }
    
    private func setupView() {
        view.backgroundColor = view.userInterface == .dark ? .surfaceBackground : .surfaceBackgroundInverse
        view.addSubview(collection)
        view.setFittingConstraints(childView: collection, insets: .zero)
        collection.contentInsetAdjustmentBehavior = .never
    }
    
    private func bind() {
    
        let output = viewModel.transform(input: .init(nextPage: collection.nextPage ))
        
        output.videos
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.endLoadingAnimation()
            })
            .sink {
                print("(ERROR) err: ", $0.err?.localizedDescription)
            } receiveValue: { [weak self] in
                self?.collection.reloadData(.init(sections: [$0]))
            }
            .store(in: &bag)
    }
}
