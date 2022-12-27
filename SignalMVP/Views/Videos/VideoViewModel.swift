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
    private var nextPage: Int = 0
    private var videos: [VideoModel]?
    
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
            .flatMap { [weak self] _ in VideoService.shared.fetchVideo(page: self?.nextPage ?? 0, limit: 5) }
            .compactMap { [weak self] in self?.decodeVideos($0.data) }
            .eraseToAnyPublisher()
        
        return .init(videos: videos)
        
    }
    
    private func getNextPageToken(videos: [VideoModel]){
        guard !videos.isEmpty else { return }
        nextPage += 1
    }
    
    private func decodeVideos(_ videos: [VideoModel]) -> CollectionSection {
        getNextPageToken(videos: videos)
        print("(DEBUG) videos: ", videos.map { $0.newsId })
        
        if self.videos == nil {
            self.videos = videos
        } else {
            self.videos?.append(contentsOf: videos)
        }
        
        
        let collectionCells: [CollectionCellProvider] = self.videos?.compactMap {
            CollectionItem<VideoTikTokCell>($0)
        } ?? []
        return CollectionSection(cell: collectionCells)
    }
    
}
