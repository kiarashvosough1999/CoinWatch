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
            Text(price.getFlag)
                .font(.footnote)
            Spacer()
            Text(price.price, format: .currency(code: price.currency))
                .font(.headline)
                .contentTransition(.numericText())
                .animation(.easeInOut, value: price.price)
        }
    }
}

extension PriceView: Equatable {}

extension CoinDetailEntity.Price {
    
    fileprivate var getFlag: String {
        let currencyToCountry: [String: String] = [
            "USD": "US",
            "EUR": "EU",
            "GBP": "GB"
        ]
        
        guard let countryCode = currencyToCountry[currency.uppercased()] else {
            return currency.uppercased()
        }

        let base: UInt32 = 127397
        var scalarString = ""
        for scalar in countryCode.uppercased().unicodeScalars {
            if let scalar = UnicodeScalar(base + scalar.value) {
                scalarString.unicodeScalars.append(scalar)
            }
        }
        return scalarString
    }
}
