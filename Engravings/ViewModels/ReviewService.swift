//
//  ReviewService.swift
//  Engravings
//
//  Created by Anna Miksiuk on 23.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import Foundation
import StoreKit

protocol ReviewServiceProtocol {
    func wasEvent()
    func isOn() -> Bool
}

class ReviewService: ReviewServiceProtocol {
    
    private static let kReviewServiceCounterEvent = "kReviewServiceCounter"
    private static let kReviewServiceOff = "kReviewServiceOff"
    
    private var counterEvent = 0 {
        didSet {
            UserDefaults.standard.set(counterEvent, forKey: ReviewService.kReviewServiceCounterEvent)
            if counterEvent == controlEvent {
                isOff = true
                requestReview()
            }
        }
    }
    private var controlEvent = 15
    private var isOff = false {
        didSet {
            UserDefaults.standard.set(isOff, forKey: ReviewService.kReviewServiceOff)
        }
    }
    
    init() {
        let number = UserDefaults.standard.value(forKey: ReviewService.kReviewServiceCounterEvent) as? Int
        if number != nil {
            counterEvent = number!
        }
        let flag = UserDefaults.standard.value(forKey: ReviewService.kReviewServiceOff) as? Bool
        if flag != nil {
            isOff = flag!
        }
    }
    
    // MARK: - Private
    
    private func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    // MARK: - ReviewServiceProtocol
    
    func wasEvent() {
        counterEvent += 1
    }
    
    func isOn() -> Bool {
        return !isOff
    }
}
