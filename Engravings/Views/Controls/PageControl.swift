//
//  PageControl.swift
//  Engravings
//
//  Created by Anna Miksiuk on 13.08.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit

class PageControl: UIPageControl {
    
    let selectDotImage = UIImage(named: "selectDot")!
    let unselectDotImage = UIImage(named: "unselectDot")!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
        self.clipsToBounds = false
    }
    
    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    func updateDots() {
        var i = 0
        for view in self.subviews {
            if let imageView = self.imageForSubview(view) {
                if i == self.currentPage {
                    imageView.image = selectDotImage
                } else {
                    imageView.image = unselectDotImage
                }
                i += 1
            } else {
                var dotImage = unselectDotImage
                if i == self.currentPage {
                    dotImage = selectDotImage
                }
                view.clipsToBounds = false
                view.addSubview(UIImageView(image: dotImage))
                i += 1
            }
        }
    }
    
    fileprivate func imageForSubview(_ view:UIView) -> UIImageView? {
        var dot:UIImageView?
        
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        
        return dot
    }
}
