//
//  ContentView.swift
//  SwiftIAP
//
//  Created by Bill Martensson on 2020-12-10.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var iaphelp = IAPHelper()
    
    var body: some View {
        VStack {
            Text(iaphelp.product1title)
                .padding()
            
            Text(iaphelp.product1description)
                .padding()
            
            Text(iaphelp.product1price)
                .padding()
            
            Button("Köp", action: {
                iaphelp.buyProduct1()
            }).padding()
            
            Text(iaphelp.product2title)
                .padding()
            
            Text(iaphelp.product2description)
                .padding()
            
            Text(iaphelp.product2price)
                .padding()
            
            Button("Köp 2", action: {
                iaphelp.buyProduct2()
            }).padding()
            
            
            Button("Återställ", action: {
                iaphelp.restorePurchases()
            })
            
        }.onAppear() {
            iaphelp.requestProductData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
