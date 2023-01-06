//
//  RatingChart.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 05/11/2022.
//

import Foundation
import UIKit

struct ChartCandleModel {
    let positive: Int
    let neutral: Int
    let negative: Int
}

//MARK: - RatingChart

class RatingChart: UIView {
    
    private lazy var stack: UIStackView = { .VStack(subViews: [positiveStack, negativeStack], spacing: 5) }()
    private lazy var positiveStack: UIStackView = { .HStack(spacing: iterSpacing, alignment: .bottom) }()
    private lazy var negativeStack: UIStackView = { .HStack(spacing: iterSpacing, alignment: .top) }()
    private let iterSpacing: CGFloat = 3
    
    override func layoutSubviews() {
        setupView()
    }
    
    private func setupView() {
        removeChildViews()
        addSubview(stack)
        setFittingConstraints(childView: stack, insets: .zero)
        positiveStack.setFrame(width: frame.width, height: itemHeight)
        negativeStack.setFrame(width: frame.width, height: itemHeight)
    }
        
    func configureChart(model: [ChartCandleModel]) {
        positiveStack.removeChildViews()
        negativeStack.removeChildViews()
        let itemWidth = itemWidth(count: model.count)
        model.forEach {
            let positive = CGFloat($0.positive)
            let negative = CGFloat($0.negative)
            let neutral = CGFloat($0.neutral)
            let total = positive + neutral + negative
            
            let positiveFactor: CGFloat = positive/total
            let nonNegativeFactor: CGFloat = (positive + neutral)/total
            let negativeFactor: CGFloat = negative/total
            
            let positiveFrame = CGSize(width: itemWidth, height: itemHeight * nonNegativeFactor)
            let positiveCandle = RatingChartCandle(factor: positiveFactor/nonNegativeFactor, color: .appGreen, size: positiveFrame, fillMode: .bottomTop)
            positiveCandle.setFrame(positiveFrame)
            positiveStack.addArrangedSubview(positiveCandle)
            
            let negativeFrame = CGSize(width: itemWidth, height: itemHeight * negativeFactor)
            let negativeCandle = RatingChartCandle(factor: 1, color: .appRed, size: negativeFrame, fillMode: .bottomTop)
            negativeCandle.setFrame(negativeFrame)
            negativeStack.addArrangedSubview(negativeCandle)
        
        }
    }
}

//MARK: - RatingChart Extension

extension RatingChart {
    
    func itemWidth(count: Int) -> CGFloat {
        let count = CGFloat(count)
        let space = (count - 1) * iterSpacing
        return (frame.width - space)/count
    }
    
    var itemHeight: CGFloat {
        (frame.height - stack.spacing).half
    }
}
