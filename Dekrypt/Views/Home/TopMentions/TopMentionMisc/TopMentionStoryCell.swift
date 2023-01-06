//
//  TopMentionStoryCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 06/11/2022.
//

import Foundation
import UIKit
import Combine

//MARK: - Defination
fileprivate extension MentionTickerModel {
    
    var tickerImage: String {
        let url = "https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@1a63530be6e374711a8554f31b17e4cb92c25fa5/128/color/\(ticker.lowercased()).png"
        return url
    }
}

//MARK: - TopMentionStoryCell

class TopMentionStoryCell: ConfigurableCollectionCell {

    static var visitedCells: Set<MentionTickerModel> = []

    private lazy var imageView: UIImageView =  { .init(size: .init(squared: 62), cornerRadius: 31, contentMode: .center) }()
    private var bag: Set<AnyCancellable> = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.setFittingConstraints(childView: imageView, centerX: 0, centerY: 0)
    }
    
    func configure(with model: MentionCellModel) {
        imageView.image = nil
        UIImage.loadImage(url: model.model.tickerImage, at: imageView, path: \.image, resized: .init(squared: 50)).store(in: &bag)
        let border = Shapes.circle(color: model.model.color, width: 2).shapeLayer(at: imageView.layer)
        border?.animate(.circularProgress(to: 1))
    }
    
}
