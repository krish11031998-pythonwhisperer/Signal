//
//  VideoScreen.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/11/2022.
//

import Foundation
import UIKit
import youtube_ios_player_helper

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
        standardNavBar(leftBarButton: .init(customView: "Video".heading2().generateLabel), rightBarButton: nil, color: .clear, scrollColor: .clear)
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


//MARK: - VideoCell

class VideoTikTokCell: ConfigurableCollectionCell {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView.init()
        view.contentMode = .scaleAspectFill
        return view
    }()
    private lazy var symbolView: TickerSymbolView = { .init() }()
    private lazy var videoContentView: UIStackView = { .VStack(spacing: 10, alignment: .leading) }()
    private lazy var videolabel: UILabel = { .init() }()
    private lazy var videoDescription: UILabel = { .init() }()
    private lazy var channelLabel: UILabel = { .init() }()
    private lazy var videoPlayer: YTPlayerView = {
        let player: YTPlayerView = .init()
        player.delegate = self
        return player
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addBlurView()
        contentView.addSubview(imageView)
        [imageView, videoPlayer].addToView(contentView)
        videoPlayer.isHidden = true
        contentView.setFittingConstraints(childView: imageView, insets: .zero)
        contentView.setFittingConstraints(childView: videoPlayer, insets: .zero)
        
        let videoDescriptionButton = videoDescription.buttonify { [weak self] in
            self?.updateView()
        }
        
        
        [.spacer(), channelLabel, videolabel, videoDescriptionButton, symbolView, .spacer(height: .safeAreaInsets.bottom + 50)].addToView(videoContentView)
        contentView.addSubview(videoContentView)
        contentView.setFittingConstraints(childView: videoContentView, insets: .init(by: 10))
        videolabel.numberOfLines = 0
        videoDescription.numberOfLines = 1
        videoDescription.contentMode = .top
    }
    
    private func updateView() {
        videoDescription.numberOfLines = videoDescription.numberOfLines == 0 ? 1 : 0
        UIView.animate(withDuration: 0.5) {
            self.videoDescription.superview?.layoutIfNeeded()
        }
    }
    
    func configure(with model: VideoModel) {
        imageView.image = nil
        videoDescription.numberOfLines = 1
        UIImage.loadImage(url: model.imageUrl, at: imageView, path: \.image, resized: .init(width: .totalWidth, height: .totalHeight), resolveWithAspectRatio: true)
        model.title.body1Medium().render(target: videolabel)
        model.sourceName.body3Regular(color: .lightGray).render(target: channelLabel)
        model.text.body3Regular().render(target: videoDescription)
        symbolView.configTickers(news: model)
        videoPlayer.loadVideo(byURL: model.newsUrl, startSeconds: 0)
        videoPlayer.isHidden = false
        videoPlayer.playVideo()
    }
}


//MARK: - VideoTikTokCell-YTPlayerDelegate
extension VideoTikTokCell: YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .unstarted:
            print("(DEBUG) unstarted")
        case .ended:
            print("(DEBUG) ended")
        case .playing:
            print("(DEBUG) playing")
        case .paused:
            print("(DEBUG) paused")
        case .buffering:
            print("(DEBUG) buffering")
        case .cued:
            print("(DEBUG) cued")
        case .unknown:
            print("(DEBUG) unknown")
        @unknown default:
            fatalError()
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.isHidden = false
    }
}
