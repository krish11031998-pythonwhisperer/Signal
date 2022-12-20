//
//  RoundeButtonCell.swift
//  baraka-styleui
//
//  Created by Krishna Venkatramani on 01/11/2022.
//

import Foundation
import UIKit

//MARK: - RoundedButtonCellModel

protocol RoundedButtonCellType {
    var model: RoundedCardViewConfig { get set }
}

struct RoundedButtonCellModel: RoundedButtonCellType, ActionProvider {
    var model: RoundedCardViewConfig
    var action: Callback?
}


//MARK: - RoundedButtonCellConfigurable

protocol RoundedButtonCellConfigurable: RoundedCardViewConfigurable {
    func reflectSelectedState()
}

//MARK: - RoundedButtonCell

class RoundedButtonCell<Model: RoundedButtonCellType>: ConfigurableCell, RoundedButtonCellConfigurable  {

    var appearance: RoundedCardAppearance { .default }
    fileprivate var model: RoundedCardViewConfig?
    public lazy var roundedView: RoundedCardView = { .init(appearance: appearance) }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(roundedView)
        contentView.setFittingConstraints(childView: roundedView, insets: .init(vertical: 7.5, horizontal: 10))
        selectionStyle = .none
        contentView.backgroundColor = .black
    }
    
    func configure(with model: Model) {
        roundedView.configureView(with: model.model)
        self.model = model.model
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        guard self.isSelected != selected else { return }
        super.setSelected(selected, animated: animated)
        reflectSelectedState()
    }
    
    func reflectSelectedState() {
        let active = isSelected || isHighlighted
        if active {
            isUserInteractionEnabled = false
            roundedView.layer.multipleAnimation(animation: [.bouncy, .fadeInOut()])
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.setSelected(false, animated: true)
            }
        } else {
            print("(DEBUG) resetting.....")
            roundedView.layer.animate(.fadeIn(), removeAfterCompletion: false)
            isUserInteractionEnabled = true
        }
    }
    
    func updateTrailingView(newView: RoundedCardViewSideView, animate: Bool, hideTrailingStack: Bool) {
        roundedView.updateTrailingView(newView: newView, animate: animate, hideTrailingStack: hideTrailingStack)
    }
    
    func updateLeadingView(newView: RoundedCardViewSideView, animate: Bool, hideLeadingStack: Bool) {
        roundedView.updateLeadingView(newView: newView, animate: animate, hideLeadingStack: hideLeadingStack)
    }
    
    func updateTitle(newTitle: RenderableText) {
        roundedView.updateTitle(newTitle: newTitle)
    }
    
    func updateSubTitle(newSubTitle: RenderableText) {
        roundedView.updateSubTitle(newSubTitle: newSubTitle)
    }
    
    func updateCaption(newCaption: RenderableText) {
        roundedView.updateCaption(newCaption: newCaption)
    }
    
    func updateSubCaption(newSubCaption: RenderableText) {
        roundedView.updateSubCaption(newSubCaption: newSubCaption)
    }

    func updateTrailingView(newView: RoundedCardViewSideView, insertAnimation: Animation? = nil, exitAnimation: Animation? = nil, hideTrailingStack: Bool) {
        roundedView.updateTrailingView(newView: newView, insertAnimation: insertAnimation, exitAnimation: exitAnimation, hideTrailingStack: hideTrailingStack)
    }
    
    func updateLeadingView(newView: RoundedCardViewSideView, insertAnimation: Animation? = nil, exitAnimation: Animation? = nil, hideLeadingStack: Bool) {
        roundedView.updateLeadingView(newView: newView, insertAnimation: insertAnimation, exitAnimation: exitAnimation, hideLeadingStack: hideLeadingStack)
    }
    
}
