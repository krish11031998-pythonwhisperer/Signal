//
//  VideoScreen.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/11/2022.
//

import Foundation
import UIKit
import youtube_ios_player_helper

fileprivate extension YTPlayerView {
    static let videoParams: [AnyHashable: Any] = ["iv_load_policy": 3,
                                                  "controls": 0,
                                                  "playsinline": 1,
                                                  "modestbranding": 1, "autoplay": 1]
}

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

//MARK: - SeekDirection
enum SeekDirection {
    case forward, backward, none
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
        return player
    }()
    
    private var tapCount: Int = 0

    private var seekDirection: SeekDirection = .none {
        didSet { seekTo() }
    }
    
    private var videoPlayerState: YTPlayerState = .unknown {
        didSet { updateVideoPlayerWithState() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
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
        UIView.animate(withDuration: 0.15) {
            self.videoDescription.superview?.layoutIfNeeded()
        }
    }
    
    private func loadVideo(videoUrl: String) {
        let id = String(videoUrl.split(separator: "=").last ?? "")
        videoPlayer.load(withVideoId: id, playerVars: YTPlayerView.videoParams)
    }
    
    func configure(with model: VideoModel) {
        imageView.image = nil
        videoDescription.numberOfLines = 1
        videoPlayerState = .unknown
        UIImage.loadImage(url: model.imageUrl, at: imageView, path: \.image, resized: .init(width: .totalWidth, height: .totalHeight), resolveWithAspectRatio: true)
        model.title.body1Medium().render(target: videolabel)
        model.sourceName.body3Regular(color: .lightGray).render(target: channelLabel)
        model.text.body3Regular().render(target: videoDescription)
        symbolView.configTickers(news: model)
        loadVideo(videoUrl: model.newsUrl)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)

        guard  location.x <= .totalWidth * 0.3 || location.x >= .totalWidth * 0.66 else {
            self.updateVideoState()
            return
        }
        
        if location.x <= .totalWidth * 0.3 {
            self.tapCount += 1
            self.seekDirection = .backward
        }
        
        if location.x >= .totalWidth * 0.66 {
            self.tapCount += 1
            self.seekDirection = .forward
        }
    }
}


//MARK: - VideoTikTokCell - Video Player
extension VideoTikTokCell {
    private func updateVideoState() {
        videoPlayer.playerState {[weak self] state, err in
            guard let `self` = self, err == nil else { return }
            switch state {
            case .cued, .unstarted, .paused:
                self.videoPlayerState = .playing
            case .playing:
                self.videoPlayerState = .paused
            default:
                self.videoPlayerState = state
            }
        }
    }
    
    private func updateVideoPlayerWithState() {
        switch videoPlayerState {
        case .cued, .unstarted, .paused:
            self.videoPlayer.pauseVideo()
            self.videoContentView.layer.animate(.fadeIn())
        case .playing:
            self.videoPlayer.isHidden = false
            self.videoPlayer.playVideo()
            self.videoContentView.layer.animate(.fadeOut(to: 0.1))
        default:
            self.videoPlayer.stopVideo()
            self.videoPlayer.isHidden = true
            self.videoContentView.layer.animate(.fadeIn())
        }
    }
    
    private func seekTo() {
        guard tapCount >= 2 else { return }
        videoPlayer.currentTime {[weak self] time, err in
            guard let `self` = self, err == nil else { return }
            switch self.seekDirection {
            case .forward:
                self.videoPlayer.seek(toSeconds: time + 10, allowSeekAhead: true)
            case .backward:
                self.videoPlayer.seek(toSeconds: time - 10, allowSeekAhead: true)
            default:
                break
            }
            self.tapCount = 0
        }
    }
}
 
