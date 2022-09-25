//
//  TrendingHeadlineCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit

class TrendingHeadlineCell: ConfigurableCell {
	
//MARK: - Properties
	private lazy var headlineLabel: UILabel = { .init() }()
	private lazy var desciptionLabel: UILabel = { .init() }()
	private lazy var sentimentStack: UIStackView = { .HStack(spacing: 8) }()
	private lazy var tickers: UIStackView = { .HStack(spacing: 8) }()
	private lazy var mainStack: UIStackView = { .VStack(spacing: 8) }()

//MARK: - Constructors
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}

//MARK: - Protected Methods
	
	private func setupView() {
		[headlineLabel, desciptionLabel, sentimentStack, tickers].forEach(mainStack.addArrangedSubview(_:))
		mainStack.setCustomSpacing(12, after: sentimentStack)
		
		tickers.isHidden = true
		headlineLabel.numberOfLines = 0
		desciptionLabel.numberOfLines = 2
		
		let divider = UIView.divider(color: .white)
		mainStack.addArrangedSubview(divider.embedInView(insets: .init(top: 10, left: 0, bottom: 0, right: 0)))
		
		contentView.addSubview(mainStack)
		contentView.setFittingConstraints(childView: mainStack, insets: .init(vertical: 10, horizontal: 16))
		
		selectionStyle = .none
		backgroundColor = .clear
		
	}
	
//MARK: - Exposed Methods
	func configure(with model: TrendingHeadlinesModel) {
		
		model.headline.styled(font: .systemFont(ofSize: 15, weight: .medium)).render(target: headlineLabel)
		model.text.styled(font: .systemFont(ofSize: 10, weight: .light)).render(target: desciptionLabel)
		
		sentimentStack.removeChildViews()
		["Sentiment : ".styled(font: .systemFont(ofSize: 12, weight: .regular)).generateLabel,
		 model.sentimentBlob, .spacer()].forEach(sentimentStack.addArrangedSubview(_:))

		if !model.tickers.isEmpty {
			tickers.isHidden = false
			tickers.removeChildViews()
			tickers.addArrangedSubview("Tickers : ".styled(font: .systemFont(ofSize: 12, weight: .regular)).generateLabel)
			model.tickers.limitTo(to: 3).forEach { ticker in
				let label = ticker.styled(font: .systemFont(ofSize: 10, weight: .semibold)).generateLabel
				tickers.addArrangedSubview(label.blobify(cornerRadius: 10))
			}
			tickers.addArrangedSubview(.spacer())
		}
		
		
		
	}
	
}
