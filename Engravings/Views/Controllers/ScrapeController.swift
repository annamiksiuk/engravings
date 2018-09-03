//
//  ScrapeController.swift
//  Engravings
//
//  Created by Anna Miksiuk on 19.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit

class ScrapeController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var engravingView: EngravingView!
    @IBOutlet weak var fingerImageView: UIImageView!
    
    // MARK: - Properties
    
    let startService = StartService()
    
    // MARK: - Actions
    
    @IBAction func actionCamera(_ sender: UIButton) {
        guard let screenshot = view.imageForView() else { return }
        let activityController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func actionEraser(_ sender: UIButton) {
        engravingView.engravingPoints.removeAll()
        engravingView.setNeedsDisplay()
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let number = arc4random_uniform(10000) % 7 + 1
        backgroundImage.image = UIImage(named: "board" + String(number))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        engravingView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        engravingView.addGestureRecognizer(panGesture)
        
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
        let scrapePoint = EngravingPoint(coordinate: point)
        if !engravingView.engravingPoints.contains(where: { (engravingPoint) -> Bool in
            return engravingPoint.coordinate == point
        }) {
            engravingView.engravingPoints.append(scrapePoint)
            engravingView.setNeedsDisplay()
        }
    }
}

