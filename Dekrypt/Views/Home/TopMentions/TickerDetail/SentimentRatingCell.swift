//
//  SentimentRatingCell.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 10/01/2023.
//

import Foundation
import UIKit

class SentimentRatingCell: ConfigurableCell {
    
    private lazy var ratingChart: RatingChart = { .init() }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        ratingChart.setFrame(width: .totalWidth - 20, height: 125)
        contentView.addSubview(ratingChart)
        contentView.setFittingConstraints(childView: ratingChart, insets: .init(vertical: 0, horizontal: 10))
        selectionStyle = .none
        backgroundColor = .surfaceBackground
    }
    
    func configure(with model: [ChartCandleModel]) {
        ratingChart.configureChart(model: model)
    }
}
