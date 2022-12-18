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
