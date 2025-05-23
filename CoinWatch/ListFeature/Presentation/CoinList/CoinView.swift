//
//  CoinView.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import SwiftUI

struct CoinView: View {

    let coin: CoinEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "bitcoinsign.circle.fill")
                Text(coin.symbol)
                Text(coin.date, style: .date)
                    .font(.footnote)
                Spacer()
                Text(coin.price, format: .currency(code: "USD"))
                    .font(.headline)
                    .contentTransition(.numericText())
                    .animation(.easeInOut, value: coin.price)
            }
        }
    }
}

extension CoinView: Equatable {}

#Preview {
    @Previewable @State var price: Double = 100000
    CoinView(
        coin: CoinEntity(
            id: "id",
            symbol: "BTC",
            price: price,
            date: .now
        )
    )
    .onReceive(
        Timer
            .publish(every: 2, on: .main, in: .default)
            .autoconnect()
            .map { _ in Double.random(in: 100000...1000000) }
    ) { newPrice in
        price = newPrice
    }
}
