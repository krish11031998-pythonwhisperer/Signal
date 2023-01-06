//
//  LoadingIndicator.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 28/12/2022.
//

import Foundation
import UIKit

class LoadingIndicator: ConfigurableCell {

    private lazy var spinner: UIActivityIndicatorView = { .init(style: .medium) }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(spinner)
        contentView.setFittingConstraints(childView: spinner, top: 20, bottom: 20, width: 50, height: 50, centerX: 0)
    }
    
    func configure(with model: EmptyModel) {
        spinner.startAnimating()
    }
}
