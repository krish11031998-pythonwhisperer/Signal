//
//  RadialChart.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 09/01/2023.
//

import Foundation
import UIKit

class RadialChart: UIView {
    
    private var chartSectionLayers: [CAShapeLayer] = []
    private let colors: [UIColor] = [.appRed, .appOrange, .appGreen]
    private var viewLayout: Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    private func setupView() {
        guard chartSectionLayers.isEmpty else { return }
        print("(DEBUG) Radial Chart Layout!")
        for i in 0..<3 {
            let startAngle:CGFloat = -(CGFloat(180 - (i * 60) - 5).boundTo(lower: 0, higher: 180))
            let endAngle:CGFloat = -(CGFloat(180 - (i+1) * 60 + 5).boundTo(lower: 0, higher: 180))
            let layer = layer.addCircularProgress(startAngle: startAngle.toRadians(),
                                                  endAngle: endAngle.toRadians(),
                                                  lineWidth: 10,
                                                  strokeColor: colors[i],
                                                  clockwise: true,
                                                  isSemiCircle: true,
                                                  animateStrokeEnd: true)
            layer.fillColor = UIColor.clear.cgColor
            chartSectionLayers.append(layer)
        }
    }
    
    func configureView(val: CGFloat, total: CGFloat = 1) {
        var val: CGFloat = (val/total) * 3
        DispatchQueue.main.async {
            self.chartSectionLayers.enumerated().forEach { layer in
                let toVal = val > 1 ? 1 : val
                guard toVal >= 0 else { return }
                layer.element.animate(.circularProgress(from: 0, to: toVal, duration: 1, delay: CFTimeInterval(layer.offset) * 1))
                val -= 1
            }
        }
        
    }
    
    
}

