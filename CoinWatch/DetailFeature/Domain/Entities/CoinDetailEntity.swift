//
//  CoinDetailEntity.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Foundation

struct CoinDetailEntity: Identifiable {

    let id: String
    let symbol: String
    let date: Date
    let prices: [Price]

    struct Price: Identifiable, Equatable {
        let id: String
        let price: Double
        let currency: String
    }
}

extension CoinDetailEntity: Equatable {}
