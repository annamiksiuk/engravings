//
//  ScrapePictureController.swift
//  Engravings
//
//  Created by Anna Miksiuk on 22.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit

class ScrapePictureController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var engravingView: EngravingView!
    @IBOutlet weak var fingerImageView: UIImageView!
    
    // MARK: - Properties
    
    var picture: Picture?
    var imagePoints = 0
    var isOpen = false
    var reviewService = ReviewService()
    var dataService = DataService()
    let startService = StartService()
    
    // MARK: - Actions
    
    @IBAction func actionBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = picture?.image
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        engravingView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        engravingView.addGestureRecognizer(panGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imagePoints = Int(backgroundImage.frame.width * backgroundImage.frame.height)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if startService.scrapeControllerFirstRun() {
            fingerImageView.isHidden = false
            animateSupportScrape(view: fingerImageView)
        }
    }
    
    // MARK: - Gestures
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        
        if startService.scrapeControllerFirstRun() {
            startService.scrapeControllerWasEvent()
            cancelSupportAnimation(view: fingerImageView)
        }
        let point = sender.location(in: engravingView)
        let scrapePoint = EngravingPoint(coordinate: CGPoint(x: Int(point.x), y: Int(point.y)))
        if !engravingView.engravingPoints.contains(where: { (engravingPoint) -> Bool in
            return engravingPoint.coordinate == scrapePoint.coordinate
        }) {
            engravingView.engravingPoints.append(scrapePoint)
            engravingView.setNeedsDisplay()
            guard let image = picture else { return }
            if let blackImage = engravingView.imageForView() {
                if blackImage.containsClearPixel(moreThanPercent: 40) {
                    if !isOpen {
                        isOpen = true
                        image.visible = true
                        dataService.saveValueForPicture(name: image.name)
                        animateShowPicture()
                        if self.reviewService.isOn() {
                            self.reviewService.wasEvent()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Animations
    
    func animateShowPicture() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.backgroundImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        self.engravingView.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundImage.transform = .identity
            })
        }
    }
    
    // MARK: - Private
}
