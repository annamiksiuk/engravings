//
//  TopicController.swift
//  Engravings
//
//  Created by Anna Miksiuk on 22.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit

class TopicController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var pageControl: PageControl!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    // MARK: - Properties
    
    let startService = StartService()
    var pictures = [Picture]()
    var pageIndex = 0
    
    // MARK: - Actions
    
    @IBAction func actionDraw(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyboard.instantiateViewController(withIdentifier: "ScrapeControllerID")
        toVC.transitioningDelegate = self
        present(toVC, animated: true, completion: nil)
        
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = pictures.count
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        pictureImageView.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changePage()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Gestures
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyboard.instantiateViewController(withIdentifier: "ScrapePictureControllerID") as! ScrapePictureController
        toVC.picture = pictures[pageIndex]
        toVC.transitioningDelegate = self
        present(toVC, animated: true, completion: nil)
    }
    
    @objc func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        if pageIndex < pictures.count - 1 {
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
            pageIndex = pictures.count - 1
        }
        changePage()
    }
    
    // MARK: - Private
    
    func changePage() {
        
        var visibleImage = UIImage(named: "question")!
        pictureImageView.contentMode = .center
        if pictures[pageIndex].visible {
           visibleImage = pictures[pageIndex].image
            pictureImageView.contentMode = .scaleToFill
        }
        
        UIView.transition(with: pictureImageView,
                          duration: 0.3,
                          options: .transitionFlipFromLeft,
                          animations: { [unowned self] in
                            self.pictureImageView.image = visibleImage
            },
                          completion: nil)
        pageControl.currentPage = pageIndex
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate

extension TopicController: UIViewControllerTransitioningDelegate {
    
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
