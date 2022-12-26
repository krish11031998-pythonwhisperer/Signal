//
//  VideoViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 18/12/2022.
//

import Foundation
import Combine

class VideoViewModel {
    
    private var bag: Set<AnyCancellable> = .init()
    private var nextPage: String?
    
    struct Input {
        let nextPage: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        let videos: AnyPublisher<CollectionSection, Error>
    }
    
    func transform(input: Input) -> Output {
        
        let videos = input.nextPage
            .prepend(true)
            .removeDuplicates()
            .filter { $0 == true }
            .flatMap { [weak self] _ in
                VideoService.shared.fetchVideo(after: self?.nextPage)
            }
            .compactMap { [weak self] in self?.decodeVideos($0.data) }
            .eraseToAnyPublisher()
        
        return .init(videos: videos)
        
    }
    
    private func decodeVideos(_ videos: [VideoModel]) -> CollectionSection {
        let collectionCells: [CollectionCellProvider] = videos.map {
            CollectionItem<VideoTikTokCell>($0)
        }
        return CollectionSection(cell: collectionCells)
    }
    
    var videos: AnyPublisher<CollectionSection, Never> {
        StubVideoService.shared
            .fetchVideo()
            .catch({ err in
                print("(DEBUG) Err: ", err)
                return Just(VideoResult(data: []))
            })
            .compactMap { $0.data }
            .map {
                let collectionCells: [CollectionCellProvider] = $0.map {
                    CollectionItem<VideoTikTokCell>($0)
                }
                return CollectionSection(cell: collectionCells)
            }
            .eraseToAnyPublisher()
    }
    
}
