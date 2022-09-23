//
//  TweetMetricView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit

fileprivate extension UIView {
	
	func blobify() -> UIView {
		blobify(backgroundColor: .white.withAlphaComponent(0.1),
				edgeInset: .init(vertical: 7.5, horizontal:7.5),
				borderColor: .white,
				borderWidth: 1,
				cornerRadius: 10)
	}
}

class TweetMetricsView: UIView {
	
	private lazy var selectedMetric: TweetSentimentMetric? = nil
	private lazy var mainStack: UIStackView = { .VStack(spacing: 12) }()
	private var progressBars: [ProgressBar] = []
	private var metricViews: [UIView] = []
	private var updateMetrics: Bool = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
		
	}
	
	
	private func setupView() {
		let views: [UIView] = TweetSentimentMetric.allCases.compactMap { metric in metric.view.blobify().buttonify {
			DispatchQueue.main.async {
				self.updateMetrics = self.selectedMetric != nil
				self.selectedMetric = metric
				self.onTap()
			}
		}}
		let flexibleStack: UIView = .flexibleStack(subViews: views + views, width: .totalWidth - 32)
		mainStack.addArrangedSubview(flexibleStack)
		addSubview(mainStack)
		setFittingConstraints(childView: mainStack, insets: .zero)
	}
	
	private func addMetricBars() {
		let stackSpacing: CGFloat = 8
		TweetSentimentMetric.allCases.forEach { metric in
			let progressBar = ProgressBar()
			let stack = UIView.VStack(subViews: [metric.rawValue.capitalized.styled(font: .systemFont(ofSize: 16, weight: .medium), color: .white).generateLabel, progressBar],
									  spacing: stackSpacing, alignment: .fill)
//			progressBar.layer.opacity = 0
			stack.layer.opacity = 0
			progressBar.setHeight(height: 20, priority: .required)
			progressBars.append(progressBar)
			metricViews.append(stack)
			mainStack.addArrangedSubview(stack)
		}
	}

	private func onTap() {
		if !updateMetrics {
			UIView.animate(withDuration: 0.0001) {
				self.addMetricBars()
			} completion: { isFinished in
				if isFinished {
					self.metricViews.enumerated().forEach { view in
						let layer = view.element.layer
						let offset:CGFloat = -view.element.frame.height.half
						let endOff = view.element.frame.minY + view.element.frame.height.half
						layer.animate(animation: .slideInFromTop(from: offset, to: endOff, duration: 0.25))
					}
					self.progressBars.forEach { $0.animateProgress(progress: .random(in: 0.15...1)) }
				}
			}
		} else {
			self.progressBars.forEach { $0.animateProgress(progress: .random(in: 0.15...1)) }
		}
		
		
	}
	
}
