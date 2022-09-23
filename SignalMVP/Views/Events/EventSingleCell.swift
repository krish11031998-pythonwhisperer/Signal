//
//  EventSingleCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

class EventSingleCell: ConfigurableCell {
	
//MARK: - Properties
	private lazy var eventTitle: UILabel = { .init() }()
	private lazy var imgView: UIImageView = {
		let imgView = UIImageView()
		imgView.contentMode = .scaleAspectFill
		imgView.cornerRadius = 10
		imgView.clipsToBounds = true
		return imgView
	}()
	
	private lazy var tickersView: UIStackView = { UIView.HStack(spacing: 8) }()
	
//MARK: - Overriden
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
		styleCell()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupViews()
		styleCell()
	}
	
//MARK: - Protected Methods
	
	private func setupViews() {
		let titleStack: UIStackView = UIView.VStack(subViews: [.spacer(),eventTitle, tickersView] ,spacing: 12)
		
		let bgView: UIView = .init()
		bgView.backgroundColor = .black.withAlphaComponent(0.35)
		imgView.addSubview(bgView)
		imgView.setFittingConstraints(childView: bgView, insets: .zero)
		
		contentView.addSubview(imgView)
		contentView.setFittingConstraints(childView: imgView, insets: .init(vertical: 8, horizontal: 16))
		imgView.setHeight(height: 200, priority: .required)
		imgView.addSubview(titleStack)
		imgView.setFittingConstraints(childView: titleStack, insets: .init(vertical: 8, horizontal: 8))
	}
	
	private func styleCell() {
		selectionStyle = .none
		backgroundColor = .clear
	}
	
	
//MARK: - Exposed Methods
	func configure(with model: EventModel) {
		
		tickersView.arrangedSubviews.forEach { $0.removeFromSuperview() }
		
		model.eventName.styled(font: .systemFont(ofSize: 15, weight: .semibold), color: .white).render(target: eventTitle)
		eventTitle.numberOfLines = 2
		
		if let firstImgURL = model.news.first?.imageUrl {
			UIImage.loadImage(url: firstImgURL, at: imgView, path: \.image)
		}
	
		tickersView.isHidden = model.tickers.isEmpty
		if !model.tickers.isEmpty {
			model.tickers.limitTo(to: 3).forEach {
				let label = UILabel()
				$0.styled(font: .systemFont(ofSize: 13, weight: .regular), color: .white).render(target: label)
				
				tickersView.addArrangedSubview(label.blobify(backgroundColor: .white.withAlphaComponent(0.3),
															 borderColor: .white,
															 borderWidth: 1,
															 cornerRadius: 10))
			}
			tickersView.addArrangedSubview(.spacer())
		}
	}
}
