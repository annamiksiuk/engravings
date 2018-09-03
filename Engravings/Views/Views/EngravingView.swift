//
//  EngravingView.swift
//  Engravings
//
//  Created by Anna Miksiuk on 19.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit

class EngravingView: UIView {

    var engravingPoints = [EngravingPoint]()
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setFillColor(UIColor.black.cgColor)
        context.addRect(rect)
        context.fillPath()
        
        context.setBlendMode(.clear)
        
        if !engravingPoints.isEmpty {
            for engravingPoint in engravingPoints {
                let point = engravingPoint.coordinate
                if rect.contains(point) {
                    context.setFillColor(UIColor.clear.cgColor)
                    context.addEllipse(in: CGRect(x: point.x - EngravingPoint.radius, y: point.y - EngravingPoint.radius, width: 2 * EngravingPoint.radius, height: 2 * EngravingPoint.radius))
                    context.fillPath()
                }
            }
        }
    }
    
}
