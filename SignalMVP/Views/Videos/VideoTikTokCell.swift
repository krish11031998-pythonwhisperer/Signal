//
//  VideoTikTokCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 15/12/2022.
//

import Foundation
import UIKit
import youtube_ios_player_helper


fileprivate extension YTPlayerView {
    static let videoParams: [AnyHashable: Any] = ["iv_load_policy": 3,
                                                  "controls": 0,
                                                  "playsinline": 1,
                                                  "modestbranding": 1,
                                                  "autoplay": 1, "loop": 1]
}

fileprivate extension YTPlayerState {
    func image(size: CGSize) -> UIImage? {
        switch self {
        case .playing:
            return .init(systemName: "play.fill")?.resized(size: size).withTintColor(.white)
        case .paused:
            return .init(systemName: "pause.fill")?.resized(size: size).withTintColor(.white)
        default:
            return nil
        }
    }
}

//MARK: - SeekDirection
enum SeekDirection {
    case forward, backward, none
}

extension SeekDirection {
    var image: UIImage? {
        switch self {
        case .forward:
            return .init(systemName: "forward.fill")
        case .backward:
            return .init(systemName: "backward.fill")
        default:
            return nil
        }
    }
}

//MARK: - VideoCell

class VideoTikTokCell: ConfigurableCollectionCell {
    
    private var model: VideoModel?
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
    
    private lazy var playerStateIndicator: UIImageView = {
        let imageView = UIImageView(circleFrame: .init(origin: .zero, size: .init(squared: 48)), contentMode: .center)
        imageView.backgroundColor = .black.withAlphaComponent(0.3)
        return imageView
    }()
    
    private var tapCount: Int = 0

    private var seekDirection: SeekDirection = .none {
        didSet { seekTo() }
    }
    
    private var videoPlayerState: YTPlayerState = .unknown {
        willSet { updateIndicator(old: videoPlayerState, new: newValue) }
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
        [videoPlayer, playerStateIndicator].addToView(contentView)
        videoPlayer.isHidden = true
        contentView.setFittingConstraints(childView: videoPlayer, insets: .zero)
        contentView.setFittingConstraints(childView: playerStateIndicator, width: 48, height: 48, centerX: 0, centerY: 0)
        playerStateIndicator.alpha = 0
        
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
        videoDescription.numberOfLines = 1
        videoPlayerState = .cued
        UIImage.loadImage(url: model.imageUrl, at: imageView, path: \.image, resized: .init(width: .totalWidth, height: .totalHeight), resolveWithAspectRatio: true)
        model.title.body1Medium().render(target: videolabel)
        model.sourceName.body3Regular(color: .lightGray).render(target: channelLabel)
        model.text.body3Regular().render(target: videoDescription)
        symbolView.configTickers(news: model)
        loadVideo(videoUrl: model.newsUrl)
        self.model = model
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)

        guard  location.x <= .totalWidth * 0.3 || location.x >= .totalWidth * 0.66 else {
            self.videoPlayerState = videoPlayerState == .playing ? .paused : .playing
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

//MARK: - VideoTikTokCell - CellFrame
extension VideoTikTokCell {
    
    private func cellFrame() -> CGPoint {
        guard let superView = superview?.superview else { return .zero }
        let cellOrigin = convert(superView.frame.origin, to: nil)
        return cellOrigin
    }
}

//MARK: - VideoTikTokCell - CollectionCellDisplay

extension VideoTikTokCell {
    func willDisplay() {
        videoPlayerState = .playing
    }
    
    func endDisplay() {
        if videoPlayerState == .playing {
            videoPlayerState = .paused
        }
    }
}
//MARK: - VideoTikTokCell - Video Player
extension VideoTikTokCell {
    
    private func updateIndicator(old: YTPlayerState, new: YTPlayerState) {
        if old == .paused && new == .playing {
            playerStateIndicator.image = new.image(size: playerStateIndicator.frame.size.half)
            playerStateIndicator.animate(.fadeInOut())
        }
        
        if old == .playing && new == .paused {
            playerStateIndicator.image = new.image(size: playerStateIndicator.frame.size.half)
            playerStateIndicator.animate(.fadeInOut())
        }
    }
    
    private func updateVideoPlayerWithState() {
        switch videoPlayerState {
        case .paused:
            self.videoPlayer.pauseVideo()
            self.videoContentView.layer.animate(.fadeIn())
        case .playing:
            self.videoPlayer.isHidden = false
            self.videoPlayer.playVideo()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.videoContentView.layer.animate(.fadeOut(to: 0.1))
            }
        default:
            break
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
            self.playerStateIndicator.image = self.seekDirection.image?.resized(size: self.playerStateIndicator.frame.size.half).withTintColor(.white)
            self.playerStateIndicator.animate(.fadeInOut())
            
        }
    }
}
 
//MARK: - VideoTikTokCell - YTplayerDelegate
extension VideoTikTokCell: YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {}
}
