//
//  Global.swift
//  Engravings
//
//  Created by Anna Miksiuk on 20.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var customOrange: UIColor {
        return UIColor(red:0.98, green:0.74, blue:0.00, alpha:1.0)
    }
    
    class var customViolet: UIColor {
        return UIColor(red:0.56, green:0.07, blue:1.00, alpha:1.0)
    }
    
    class var gradientLastColor: UIColor {
        return UIColor(red:0.99, green:0.87, blue:0.69, alpha:1.0)
    }
    
}

extension UIView {
    func imageForView() -> UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    func containsClearPixel(moreThanPercent percent: Int) -> Bool {
        let pixelsWidth = Int(self.size.width)
        let pixelsHeight = Int(self.size.height)
        
        guard let pixelData = self.cgImage?.dataProvider?.data else { return false }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var alphaCount = 0
        for x in 0..<pixelsWidth {
            for y in 0..<pixelsHeight {
                let point = CGPoint(x: x, y: y)
                let pixelInfo: Int = ((pixelsWidth * Int(point.y)) + Int(point.x)) * 4
                let alpha = CGFloat(data[pixelInfo + 3]) / 255.0
                if alpha == 0 {
                    alphaCount += 1
                }
            }
        }
        if alphaCount > pixelsWidth * pixelsHeight * percent / 100 {
            return true
        }
        return false
    }
}

// MARK: - Animations

func animateSupportTap(view: UIView) {
    UIView.animate(withDuration: 1,
                   delay: 0,
                   options: [.repeat, .autoreverse],
                   animations: {
                    let tranformScale = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    view.transform = CGAffineTransform(translationX: -10, y: 10).concatenating(tranformScale)
        },
                   completion: nil)
}

func animateSupportScrape(view: UIView) {
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   options: [.repeat, .autoreverse],
                   animations: {
                    view.transform = CGAffineTransform(translationX: -40, y: 40)
    },
                   completion: nil)
}

func cancelSupportAnimation(view: UIView) {
    
    UIView.animate(withDuration: 0.3,
                   animations: {
                    view.isHidden = true
    }) { (success) in
        view.layer.removeAllAnimations()
    }
}

// MARK: - Support

func isSmallScreen() -> Bool {
    return UIScreen.main.bounds.width < 375
}
