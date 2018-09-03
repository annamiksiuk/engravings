//
//  AppPurchaseView.swift
//  Engravings
//
//  Created by Anna Miksiuk on 15.08.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit

protocol AppPurchaseViewDelegate {
    func didClose()
    func didUnlock()
    func didRestore()
}

class AppPurchaseView: UIView {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var outsideView: UIView!
    @IBOutlet weak var insideView: UIView!
    
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    // MARK: - Properties
    
    var delegate: AppPurchaseViewDelegate?
    
    // MARK: - Actions
    
    @IBAction func actionUnlock(_ sender: UIButton) {
        delegate?.didUnlock()
    }
    
    @IBAction func actionRestore(_ sender: UIButton) {
        delegate?.didRestore()
    }
    
    // MARK: - View lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Self initializations
    
    func commonInit() {
        
        Bundle.main.loadNibNamed("AppPurchaseView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        
        insideView.layer.cornerRadius = 10
        insideView.layer.shadowColor = UIColor.lightGray.cgColor
        insideView.layer.shadowOpacity = 0.5
        insideView.layer.shadowOffset = CGSize(width: 0, height: 1)
        insideView.layer.shadowRadius = 5
        insideView.layer.masksToBounds = false
        
        unlockButton.layer.borderColor = UIColor.customViolet.cgColor
        unlockButton.layer.borderWidth = 2
        unlockButton.layer.cornerRadius = unlockButton.bounds.height / 2
        unlockButton.titleLabel?.adjustsFontSizeToFitWidth = true
        unlockButton.titleLabel?.minimumScaleFactor = 0.8
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        outsideView.addGestureRecognizer(tap)
        
    }
    
    // MARK: - Gestures
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        delegate?.didClose()
    }
}
