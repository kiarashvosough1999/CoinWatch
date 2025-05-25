//
//  CoinDetailView.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import SwiftUI

struct CoinDetailView: View {

    let coin: CoinDetailEntity

    var body: some View {
        Section {
            groupConent
        } header: {
            groupLabel
        }
    }

    private var groupConent: some View {
        ForEach(coin.prices) { price in
            PriceView(price: price)
                .equatable()
                .padding(.horizontal)
                .padding(.vertical, 4)
        }
    }
    
    private var groupLabel: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "bitcoinsign.circle.fill")
                .font(.title3)
                .foregroundStyle(.yellow)
            Text(coin.symbol)
                .font(.headline)
                .bold()
            Spacer()
            Text(coin.date, style: .date)
                .font(.footnote)
        }
        .font(.title3)
    }
}

extension CoinDetailView: Equatable {}

@available(iOS 17, *)
#Preview {
    @Previewable @State var price: Double = 100000
    List {
        CoinDetailView(
            coin: CoinDetailEntity(
                id: "id",
                symbol: "BTC",
                date: .now,
                prices: stride(from: 1, to: 10, by: 1)
                    .map { index in
                        CoinDetailEntity.Price(id: "\(index)", price: index * price, currency: "USD")
                    }
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
}
