//
//  RatingChart.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 05/11/2022.
//

import Foundation
import UIKit

//MARK: - RatingChart

class RatingChart: UIView {
    
    private lazy var stack: UIStackView = { .VStack(subViews: [positiveStack, negativeStack], spacing: 5) }()
    private lazy var positiveStack: UIStackView = { .HStack(spacing: iterSpacing, alignment: .bottom) }()
    private lazy var negativeStack: UIStackView = { .HStack(spacing: iterSpacing, alignment: .top) }()
    private var timeFrame: Int = 0
    private let iterSpacing: CGFloat = 3
    

    init(timeFrame: Int, frame: CGRect) {
        super.init(frame: frame)
        self.timeFrame = timeFrame
        //setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupView()
    }
    
    private func setupView() {
        removeChildViews()
        addSubview(stack)
        setFittingConstraints(childView: stack, insets: .zero)
        positiveStack.setFrame(width: frame.width, height: itemHeight)
        negativeStack.setFrame(width: frame.width, height: itemHeight)
        setupStack()
    }
    
    private func setupStack() {
        positiveStack.removeChildViews()
        negativeStack.removeChildViews()
        Array(repeating: 0, count: timeFrame).forEach { _ in
            let size = CGSize(width: itemWidth, height: itemHeight * CGFloat.random(in: 0.3...1))
            let candle = RatingChartCandle(factor: .random(in: 0.3...1), color: .green, size: size, fillMode: .bottomTop)
            candle.setFrame(size)
            positiveStack.addArrangedSubview(candle)
        }
        
        Array(repeating: 0, count: timeFrame).forEach { _ in
            let size = CGSize(width: itemWidth, height: itemHeight * CGFloat.random(in: 0.3...1))
            let candle = RatingChartCandle(factor: 1, color: .red, size: size, fillMode: .topBottom)
            candle.setFrame(size)
            negativeStack.addArrangedSubview(candle)
        }
        
    }
}

//MARK: - RatingChart Extension

extension RatingChart {
    
    var itemWidth: CGFloat {
        let count = CGFloat(timeFrame)
        let space = (count - 1) * iterSpacing
        return (frame.width - space)/count
    }
    
    var itemHeight: CGFloat {
        (frame.height - stack.spacing).half
    }
}
