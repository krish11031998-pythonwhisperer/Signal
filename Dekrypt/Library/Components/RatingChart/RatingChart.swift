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

extension ChartCandleModel {
    
    var positiveFactor: CGFloat {
        CGFloat(positive)/CGFloat(positive + neutral + negative)
    }
    
    var negativeFactor: CGFloat {
        CGFloat(negative)/CGFloat(positive + neutral + negative)
    }
    
    var nonNeutralFactor: CGFloat {
        CGFloat(positive + neutral)/CGFloat(positive + neutral + negative)
    }
    
}

enum CandleType {
    case positive, negative
}

//MARK: - RatingChart

class RatingChart: UIView {
    
    private lazy var stack: UIStackView = { .VStack(subViews: [positiveStack, negativeStack], spacing: 5) }()
    private lazy var positiveStack: UIStackView = { .HStack(spacing: iterSpacing, alignment: .bottom) }()
    private lazy var negativeStack: UIStackView = { .HStack(spacing: iterSpacing, alignment: .top) }()
    private var viewLayout: Bool = false
    private let iterSpacing: CGFloat = 3

    override func layoutSubviews() {
        setupView()
    }
    
    private func setupView() {
        guard subviews.isEmpty else { return }
        print("(DEBUG) setup views!")
        removeChildViews()
        addSubview(stack)
        setFittingConstraints(childView: stack, insets: .zero)
        stack.distribution = .fillEqually
        positiveStack.setFrame(width: frame.width, height: itemHeight)
        negativeStack.setFrame(width: frame.width, height: itemHeight)
    }
        
    func configureChart(model: [ChartCandleModel]) {
        positiveStack.removeChildViews()
        negativeStack.removeChildViews()
        let itemWidth = itemWidth(count: model.count)
        model.forEach {
            let positiveFrame = CGSize(width: itemWidth, height: itemHeight * $0.nonNeutralFactor)
            addCandle(type: .positive, factor: $0.positiveFactor, size: positiveFrame)
            
            let negativeFrame = CGSize(width: itemWidth, height: itemHeight * $0.negativeFactor)
            addCandle(type: .negative, factor: 1, size: negativeFrame)
        }
    }
    
    private func addCandle(type: CandleType, factor: CGFloat, size: CGSize) {
        if type == .positive {
            let positiveCandle = RatingChartCandle(factor: factor, color: .appGreen, size: size, fillMode: .bottomTop)
            positiveCandle.setFrame(size)
            positiveStack.addArrangedSubview(positiveCandle)
        } else if type == .negative {
            let negativeCandle = RatingChartCandle(factor: 1, color: .appRed, size: size, fillMode: .bottomTop)
            negativeCandle.setFrame(size)
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
