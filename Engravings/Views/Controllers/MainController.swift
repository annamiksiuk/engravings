//
//  MainController.swift
//  Engravings
//
//  Created by Anna Miksiuk on 20.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit
import StoreKit

class MainController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var pageControl: PageControl!
    @IBOutlet weak var appPurchaseView: AppPurchaseView!
    @IBOutlet weak var fingerImageView: UIImageView!
    
    // MARK: - Properties
    
    var topicImages = [UIImage]()
    var pageIndex = 0
    
    let startService = StartService()
    var dataService = DataService()
    let purchaseService = PurchaseService()
    
    // MARK: - Actions
    
    @IBAction func actionDraw(_ sender: UIButton) {
        
        if startService.mainControllerFirstRun() {
            startService.mainControllerWasEvent()
            cancelSupportAnimation(view: fingerImageView)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyboard.instantiateViewController(withIdentifier: "ScrapeControllerID")
        toVC.transitioningDelegate = self
        present(toVC, animated: true, completion: nil)
    }
    
    @IBAction func actionLock(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.appPurchaseView.alpha = 1
        }
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for topic in dataService.topics {
            guard let topicImage = UIImage(named: topic.name) else { continue }
            topicImages.append(topicImage)
        }
        
        pageControl.numberOfPages = topicImages.count
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        topicImageView.addGestureRecognizer(tap)
        
        appPurchaseView.delegate = self
        purchaseService.delegate = self
        
        changePage()
        
        if startService.mainControllerFirstRun() {
            fingerImageView.isHidden = false
            animateSupportTap(view: fingerImageView)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Gestures
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        if startService.mainControllerFirstRun() {
            startService.mainControllerWasEvent()
            cancelSupportAnimation(view: fingerImageView)
        }
        
        if !dataService.topics[pageIndex].active {
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.appPurchaseView.alpha = 1
            }
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyboard.instantiateViewController(withIdentifier: "TopicControllerID") as! TopicController
        toVC.pictures = dataService.topics[pageIndex].pictures
        toVC.transitioningDelegate = self
        present(toVC, animated: true, completion: nil)
    }
    
    @objc func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        if pageIndex < topicImages.count - 1 {
            pageIndex += 1
        } else {
            pageIndex = 0
        }
        changePage()
    }
    
    @objc func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        if pageIndex > 0 {
            pageIndex -= 1
        } else {
            pageIndex = topicImages.count - 1
        }
        changePage()
    }
    
    // MARK: - Animations
    
    // MARK: - Private
    
    func changePage() {
        UIView.transition(with: topicImageView,
                          duration: 0.3,
                          options: .transitionFlipFromLeft,
                          animations: { [unowned self] in
                            self.topicImageView.image = self.topicImages[self.pageIndex]
            },
                          completion: nil)
        
        pageControl.currentPage = pageIndex
        lockButton.isHidden = true
        if pageIndex < topicImages.count {
            let lockState = dataService.topics[pageIndex].active
            lockButton.isHidden = lockState
        }
    }
}

extension MainController: AppPurchaseViewDelegate {
    func didClose() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.appPurchaseView.alpha = 0
        }
    }
    
    func didUnlock() {
        guard let fullVersionProduct = purchaseService.iapProducts.first else { return }
        purchaseService.purchaseProduct(product: fullVersionProduct)
    }
    
    func didRestore() {
        purchaseService.restore()
    }
}

extension MainController: PurchaseServiceDelegate {
    
    func purchasesDisabled() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.appPurchaseView.alpha = 0
        }
        
        let alert = UIAlertController(title: "engravings",
                          message: "Purchases are disabled in your device!",
                          preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOK)
        present(alert, animated: true, completion: nil)
    }
    
    func purchaseProduct(productID: String) {
        if productID == purchaseService.fullVersionID {
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.appPurchaseView.alpha = 0
            }
            
            dataService = DataService()
            changePage()
        }
    }
    
    func purchasesRestore() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.appPurchaseView.alpha = 0
        }
        
        let alert = UIAlertController(title: "engravings",
                                      message: "You've successfully restored your purchase!",
                                      preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOK)
        present(alert, animated: true, completion: nil)
        
        dataService = DataService()
        changePage()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension MainController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let hideAnimator = SimpleHideTransitioning(presenting: true)
        return hideAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let hideAnimator = SimpleHideTransitioning(presenting: false)
        hideAnimator.duration = 0.5
        return hideAnimator
    }
}
