//
//  MediaSegmentControlHeader.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 09/01/2023.
//

import Foundation
import UIKit
import Combine

class MediaSegmentControl: UIView {
    
    private lazy var segmentScroll: ScrollView = { .init(axis: .horizontal) }()
    private let selectedTab: CurrentValueSubject<TickerMediaSections, Never>
    
    init(selectedTab: CurrentValueSubject<TickerMediaSections, Never>) {
        self.selectedTab = selectedTab
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let header: UILabel = "Media".heading2().generateLabel
        setupSegmentButtons()
        let stack: UIStackView = .VStack(subViews: [header, segmentScroll], spacing: 8)
        addSubview(stack)
        setFittingConstraints(childView: stack, insets: .init(top: 0, left: 10, bottom: 10, right: 10))
    }
    
    
    private func setupSegmentButtons() {
        TickerMediaSections.allCases.forEach { tabSection in
            let blob = SegmentTabCell(value: tabSection, subject: selectedTab)
            segmentScroll.addArrangedView(view: blob)
        }
    }
    
}
