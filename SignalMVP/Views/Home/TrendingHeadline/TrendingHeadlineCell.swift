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
    private lazy var sentimentLabel: UILabel = { .init() }()
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
		[headlineLabel, desciptionLabel, sentimentLabel, tickers].forEach(mainStack.addArrangedSubview(_:))
		mainStack.setCustomSpacing(12, after: sentimentStack)
		
		tickers.isHidden = true
		headlineLabel.numberOfLines = 0
		desciptionLabel.numberOfLines = 2
		
		let divider = UIView.divider()
		mainStack.addArrangedSubview(divider.embedInView(insets: .init(top: 10, left: 0, bottom: 0, right: 0)))
		
		contentView.addSubview(mainStack)
		contentView.setFittingConstraints(childView: mainStack, insets: .init(vertical: 10, horizontal: 16))
		
		selectionStyle = .none
		backgroundColor = .clear
		
	}
	
//MARK: - Exposed Methods
	func configure(with model: TrendingHeadlinesModel) {
		
		model.headline.body1Medium().render(target: headlineLabel)
		model.text.body2Regular(color: .gray).render(target: desciptionLabel)
		
        let sentimentBlob = model.sentimentBlob.toText(fontHeight: CustomFonts.regular.fontBuilder(size: 11)?.capHeight ?? 0)
        let sentimentText = sentimentBlob.appending("  ").appending(model.sentiment.rawValue.bodySmallRegular())
        
        sentimentText.render(target: sentimentLabel)

		if !model.tickers.isEmpty {
			tickers.isHidden = false
			tickers.removeChildViews()
			model.tickers.limitTo(to: 3).forEach { ticker in
				let img = SymbolImage()
				img.configureView(symbol: "", label: ticker.body3Medium())
				tickers.addArrangedSubview(img)
				img.setHeight(height: CGSize.smallestSquare.height, priority: .required)
			}
			tickers.addArrangedSubview(.spacer())
		}
	}
	
}
