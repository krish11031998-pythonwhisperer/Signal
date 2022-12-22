//
//  VideoTikTokCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 15/12/2022.
//

import Foundation
import UIKit
import youtube_ios_player_helper
import Combine

enum YTPlayerError: String, Error {
    case outOfMemory
    case stateNotFound
}

fileprivate extension YTPlayerView {
    static let videoParams: [AnyHashable: Any] = ["iv_load_policy": 3,
                                                  "controls": 0,
                                                  "playsinline": 1,
                                                  "modestbranding": 1,
                                                  "autoplay": 1, "loop": 1]
    
    func fetchPlayerState() -> Future<YTPlayerState, Error> {
        Future { [weak self] promise in
            guard let `self` = self else {
                promise(.failure(YTPlayerError.outOfMemory))
                return
            }
            print("(DEBUG playerState Call!)")
            self.playerState { state, err in
                print("(DEBUG playerState CallBack!)")
                guard err == nil else {
                    if let err = err {
                        print("(ERROR) err: ", err)
                        promise(.failure(err))
                    } else {
                        print("(ERROR) err: ", YTPlayerError.stateNotFound)
                        promise(.failure(YTPlayerError.stateNotFound))
                    }
                    return
                }
                print("(DEBUG) state: ", state)
                promise(.success(state))
            }
        }
        
    }
}


//MARK: - SeekDirection
enum PlayerState {
    case play, pause, seekForward, seekBackward, idle
}

extension PlayerState {
    var image: UIImage? {
        switch self {
        case .play:
            return .init(systemName: "play.fill")
        case .pause:
            return .init(systemName: "pause.fill")
        case .seekForward:
            return .init(systemName: "forward.fill")
        case .seekBackward:
            return .init(systemName: "backward.fill")
        default:
            return nil
        }
    }
}

//MARK: - VideoCell

class VideoTikTokCell: ConfigurableCollectionCell {
    
    private var model: VideoModel?
    private lazy var imageView: UIImageView = { .standardImageView() }()
    private lazy var symbolView: TickerSymbolView = { .init() }()
    private lazy var videoContentView: UIStackView = { .VStack(spacing: 10, alignment: .leading) }()
    private lazy var videolabel: UILabel = { .init() }()
    private lazy var videoDescription: UILabel = { .init() }()
    private lazy var channelLabel: UILabel = { .init() }()
    private var playerState: CurrentValueSubject<PlayerState, Never> = .init(.idle)
    private var bag: Set<AnyCancellable> = .init()
    
    private lazy var videoPlayer: YTPlayerView = { .init() }()
    
    private lazy var playerStateIndicator: UIImageView = {
        let imageView = UIImageView(circleFrame: .init(origin: .zero, size: .init(squared: 48)), contentMode: .center)
        imageView.backgroundColor = .black.withAlphaComponent(0.3)
        return imageView
    }()
    
    private var tapCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setObservers()
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
        playerState.send(.idle)
        UIImage.loadImage(url: model.imageUrl, at: imageView, path: \.image, resized: .init(width: .totalWidth, height: .totalHeight), resolveWithAspectRatio: true)
        model.title.body1Medium(color: .white).render(target: videolabel)
        model.sourceName.body3Regular(color: .lightGray).render(target: channelLabel)
        model.text.body3Regular(color: .white).render(target: videoDescription)
        symbolView.configTickers(news: model)
        loadVideo(videoUrl: model.newsUrl)
        self.model = model
        
    }
    
    private func setObservers() {
        playerState
        //            .combineLatest(videoPlayer.fetchPlayerState())
        //            .map { state, playerState in
        //                if state == .play && playerState == .playing {
        //                    return PlayerState.pause
        //                }
        //                if state == .pause && playerState == .paused {
        //                    return PlayerState.play
        //                }
        //
        //                return state
        //            }
        //            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: {
//                print("(ERROR) err:", $0.err?.localizedDescription)
//            }, receiveValue: { [weak self] (newPlayState: PlayerState) in
//                guard let `self` = self else { return }
//                self.updatePlayerState(newPlayState)
//            })
            .sink() { [weak self] (newPlayState: PlayerState) in
                guard let `self` = self else { return }
                self.updatePlayerState(newPlayState)
            }
            .store(in: &bag)
        
        videoPlayer
            .fetchPlayerState()
            .sink { completion in
                print("(ERR) err: ", completion.err?.localizedDescription)
            } receiveValue: { state in
                print("(DEBUG) playerState: ", state)
            }
            .store(in: &bag)
        
    }
    
    private func updatePlayerState(_ newPlayState: PlayerState) {
        switch newPlayState {
        case .idle:
            self.videoPlayer.isHidden = true
        case .play:
            self.updateIndicator(new: newPlayState)
            self.updateVideoPlayerWithState(state: newPlayState)
        case .pause:
            self.updateIndicator(new: newPlayState)
            self.updateVideoPlayerWithState(state: newPlayState)
        case .seekBackward, .seekForward:
            self.updateIndicator(new: newPlayState)
            self.seekTo()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)

        guard  location.x <= .totalWidth * 0.3 || location.x >= .totalWidth * 0.66 else {
            videoPlayer.playerState { [weak self] state, _ in
                self?.playerState.send(state == .playing ? .pause : .play)
            }
            return
        }
        
        if location.x <= .totalWidth * 0.3 {
            self.tapCount += 1
            self.playerState.send(.seekBackward)
        }
        
        if location.x >= .totalWidth * 0.66 {
            self.tapCount += 1
            self.playerState.send(.seekForward)
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
        playerState.send(.play)
    }
    
    func endDisplay() {
        if playerState.value == .play {
            playerState.send(.pause)
        }
    }
}
//MARK: - VideoTikTokCell - Video Player
extension VideoTikTokCell {
    
    private func updateIndicator(new: PlayerState) {
        playerStateIndicator.image = new.image?.resized(size: playerStateIndicator.frame.size.half).withTintColor(.white)
        playerStateIndicator.animate(.fadeInOut())
    }
    
    private func updateVideoPlayerWithState(state: PlayerState) {
        switch state {
        case .pause:
            self.videoPlayer.pauseVideo()
            self.videoContentView.layer.animate(.fadeIn())
        case .play:
            self.videoPlayer.isHidden = false
            self.videoPlayer.playVideo()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.videoContentView.animate(.fadeOut(to: 0.1))
            }
        default:
            break
        }
    }
    
    private func seekTo() {
        guard tapCount >= 2 else { return }
        videoPlayer.currentTime {[weak self] time, err in
            guard let `self` = self, err == nil else { return }
            switch self.playerState.value {
            case .seekForward:
                self.videoPlayer.seek(toSeconds: time + 10, allowSeekAhead: true)
            case .seekBackward:
                self.videoPlayer.seek(toSeconds: time - 10, allowSeekAhead: true)
            default:
                break
            }
            self.tapCount = 0
        }
    }
}
