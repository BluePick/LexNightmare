//
//  GameViewControllerWithAds.swift
//  LexNightmare
//
//  Created by Lex on 3/15/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit
import StoreKit
import iAd

class GameViewControllerWithAds: GameViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver , ADBannerViewDelegate {
    
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var removeAdsButton: UIButton!
    @IBOutlet weak var adBanner: ADBannerView!

    var inAppProductIdentifiers = NSSet()

    let removeAdsProductIdentifier = "com.LexTang.LexNightmare.remove_ads"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GameDefaults.sharedDefaults.removeAds {
            removeAdsButton.hidden = true
            restoreButton.hidden = true
            adBanner.removeFromSuperview()
        }
        
        restoreButton.titleLabel!.text = NSLocalizedString("Restore previous purchase", comment: "Restore button title")
        removeAdsButton.titleLabel!.text = NSLocalizedString("Remove ads", comment: "Remove ads button title")
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    func fetchProducts()
    {
        if SKPaymentQueue.canMakePayments() {
            var productsRequest = SKProductsRequest(productIdentifiers: Set(arrayLiteral: removeAdsProductIdentifier) as Set<NSObject>)
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    func buyProduct(product: SKProduct) {
        println("Sending the Payment Request to Apple")
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    @IBAction func restoreCompletedTransactions() {
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    @IBAction func didTapRemoveAds(sender: UIButton) {
        fetchProducts()
    }
    
    func removeAds() {
        removeAdsButton.hidden = true
        restoreButton.hidden = true
        adBanner.hidden = true
    }
    
    // MARK: - Delegate methods of IAP
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        var count = response.products.count
        if count > 0 {
            var validProducts = response.products
            var validProduct = response.products.first as! SKProduct!
            if validProduct.productIdentifier == removeAdsProductIdentifier {
                buyProduct(validProduct)
            }
        }
    }
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {

    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        for transaction in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .Purchased, .Restored:
                    println("Product purchased.")
                    SKPaymentQueue.defaultQueue().finishTransaction(trans)
                    removeAds()
                    break
                case .Purchased:
                    self.restoreCompletedTransactions()
                    SKPaymentQueue.defaultQueue().finishTransaction(trans)
                    removeAds()
                case .Failed:
                    SKPaymentQueue.defaultQueue().finishTransaction(trans)
                    break
                default:
                    ()
                }
            }
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!) {
        
    }
    
    // MARK: - Ad delegate
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        banner.alpha = 1.0
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        banner.alpha = 0.0
    }
    
}
