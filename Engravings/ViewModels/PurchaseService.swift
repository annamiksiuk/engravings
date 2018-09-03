//
//  PurchaseService.swift
//  Engravings
//
//  Created by Anna Miksiuk on 27.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit
import StoreKit

protocol PurchaseServiceDelegate {
    func purchasesDisabled()
    func purchaseProduct(productID: String)
    func purchasesRestore()
}

class PurchaseService: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    private static let kNonConsumablePurchase = "kNonConsumablePurchase"
    
    let fullVersionID = "com.annamiksiuk.EngravingsFullVersion"
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var nonConsumablePurchase = UserDefaults.standard.bool(forKey: PurchaseService.kNonConsumablePurchase)
    
    var delegate: PurchaseServiceDelegate?
    
    override init() {
        super.init()
        
        productsRequest = SKProductsRequest(productIdentifiers: NSSet(objects: fullVersionID) as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if (response.products.count > 0) {
            iapProducts = response.products
            /*
            let firstProduct = response.products[0] as SKProduct

            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = firstProduct.priceLocale
            let priceStr = numberFormatter.string(from: firstProduct.price)

            print(firstProduct.localizedDescription + "\nfor just \(priceStr!)")*/
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction:AnyObject in transactions {
            
            if let trans = transaction as? SKPaymentTransaction {
                
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    if productID == fullVersionID {
                        
                        nonConsumablePurchase = true
                        UserDefaults.standard.set(nonConsumablePurchase, forKey: PurchaseService.kNonConsumablePurchase)
                        
                        delegate?.purchaseProduct(productID: productID)
                    }
                case .restored:
                    nonConsumablePurchase = true
                    UserDefaults.standard.set(nonConsumablePurchase, forKey: PurchaseService.kNonConsumablePurchase)
                    delegate?.purchasesRestore()
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                case .purchasing:
                    break
                default:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                }
            }
        }
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
    }
    
    // MARK: - Private
    
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchaseProduct(product: SKProduct) {
        
        if self.canMakePurchases() {
            
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            productID = product.productIdentifier
            
        } else {
            delegate?.purchasesDisabled()
        }
    }
    
    func restore() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func isFullVersion() -> Bool {
        return nonConsumablePurchase
    }
    
}
