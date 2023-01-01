//
//  NewTweetMetricView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 30/12/2022.
//

import Foundation
import UIKit
import Combine

class NewTweetMetricView: UIControl {
    
    private let selectedMetric: PassthroughSubject<String, Never>
    private var metricRows: [MetricRow]?
    private let reaction: TweetReaction?
    private var bag: Set<AnyCancellable>
    init(reaction: TweetReaction?) {
        self.reaction = reaction
        self.bag = .init()
        self.selectedMetric = .init()
        super.init(frame: .zero)
        setupView()
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let mainStack = UIStackView.VStack(spacing: 10)
        mainStack.addArrangedSubview("Metrics".heading4().generateLabel.embedInView(insets: .init(vertical: 10, horizontal: 0)))
        
        let stack = UIStackView.VStack(spacing: 20)
        MetricType.allCases.forEach {
            stack.addArrangedSubview(MetricRow(type: $0,
                                               selectedMetric: self.selectedMetric))
        }
        metricRows = stack.arrangedSubviews as? [MetricRow]
        let stackCard = stack.embedViewInCard()
        stackCard.addShadow()
        mainStack.addArrangedSubview(stackCard)
        addSubview(mainStack)
        setFittingConstraints(childView: mainStack, insets: .zero)
    }
    
    private func addObservers() {
        selectedMetric
            .sink { [weak self] _ in
                guard let self else { return }
                self.metricRows?.forEach { $0.animate(value: CGFloat.random(in: 0...1)) }
            }
            .store(in: &bag)
    }
}
