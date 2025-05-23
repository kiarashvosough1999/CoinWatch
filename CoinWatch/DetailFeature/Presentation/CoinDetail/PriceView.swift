//
//  PriceView.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import SwiftUI

struct PriceView: View {
    
    let price: CoinDetailEntity.Price
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(price.cuurency)
                .font(.footnote)
            Spacer()
            Text(price.price, format: .currency(code: "USD"))
                .font(.headline)
                .contentTransition(.numericText())
                .animation(.easeInOut, value: price.price)
        }
    }
}

extension PriceView: Equatable {}
