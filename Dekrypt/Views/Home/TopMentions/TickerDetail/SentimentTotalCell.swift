//
//  SentimentTotal.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 10/01/2023.
//

import Foundation
import UIKit
import Combine

class SentimentTotalCell: ConfigurableCell {
    
    private lazy var chart: RadialChart = { .init() }()
    private lazy var sentimentInfo: DualLabel = { .init(spacing: 8, alignment: .center) }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let width = .totalWidth - 20
        chart.setFrame(width: width, height: width.half)
        contentView.addSubview(chart)
        contentView.setFittingConstraints(childView: chart, insets: .init(vertical: 0, horizontal: 10))
        
        addSubview(sentimentInfo)
        setFittingConstraints(childView: sentimentInfo, bottom: 10, centerX: 0)
        
        selectionStyle = .none
        isUserInteractionEnabled = false
        backgroundColor = .surfaceBackground
    }
    
    func configure(with model: SentimentForTicker) {
        chart.animate(.fadeIn())
        setNeedsLayout()
        guard let val = model.total?.sentimentScore else { return }
        let sentimentTotal = CGFloat((val + 1.5)/3)
        chart.configureView(val: sentimentTotal, total: 1)
        sentimentInfo.configure(title: "Social Sentiment".heading5(), subtitle: String(format: "%.2f%", sentimentTotal * 100).heading2())
    }
}
