//
//  IAPHelper.swift
//  SwiftIAP
//
//  Created by Bill Martensson on 2020-12-10.
//

import SwiftUI
import StoreKit
import Foundation

class IAPHelper : NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    let productIdentifiers = Set(["somegold", "goldmine"])
    var productsArray = Array<SKProduct>()

    @Published var product1title = ""
    @Published var product1description = ""
    @Published var product1price = ""

    @Published var product2title = ""
    @Published var product2description = ""
    @Published var product2price = ""

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func requestProductData()
    {
        print("requestProductData")
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: self.productIdentifiers as Set<String>)
            request.delegate = self
            request.start()
        } else {
            // Kan ej köpa
            print("Cannot buy")
        }
    }
    
    func buyProduct1()
    {
        let payment = SKPayment(product: productsArray[0])
        SKPaymentQueue.default().add(payment)
    }
    
    func buyProduct2()
    {
        let payment = SKPayment(product: productsArray[1])
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases()
    {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let products = response.products
        
        let currency_format = NumberFormatter()
        currency_format.numberStyle = NumberFormatter.Style.currency
        currency_format.locale = products[0].priceLocale

        if (products.count != 0) {
            for product in products
            {
                self.productsArray.append(product)
                print("*****************")
                print(product.localizedTitle)
                print(product.localizedDescription)
                print(product.price)
                print(product.priceLocale)
                
                print(currency_format.string(from: product.price))
                
            }

            DispatchQueue.main.async {
                self.product1title = self.productsArray[0].localizedTitle
                self.product1description = self.productsArray[0].localizedDescription
                self.product1price = currency_format.string(from: self.productsArray[0].price)!
                
                self.product2title = self.productsArray[1].localizedTitle
                self.product2description = self.productsArray[1].localizedDescription
                self.product2price = currency_format.string(from: self.productsArray[1].price)!
                
            }
            
            
            // title = self.productsArray[0].localizedTitle
            // price = currency_format.string(from: products[0].price)
            // description = self.productsArray[0].localizedDescription
            
            
            
        } else {
            print("No products found")
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        print("paymentQueue updatedTransactions")
                    
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
        
        
    }
    
    func deliverProduct(_ transaction:SKPaymentTransaction) {
        print("deliverProduct "+transaction.payment.productIdentifier)
        if transaction.payment.productIdentifier == "somegold"
        {
            print("somegold bought")
        }
        else if transaction.payment.productIdentifier == "goldmine"
        {
            print("goldmine bought")
        }
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Transactions Restored")
            
        for transaction:SKPaymentTransaction in queue.transactions
        {
            print(transaction.payment.productIdentifier)
            if transaction.payment.productIdentifier == "somegold"
            {
                print("somegold Restored")
            }
            else if transaction.payment.productIdentifier == "goldmine"
            {
                print("goldmine Restored")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("Restore failed")
    }
    
}
