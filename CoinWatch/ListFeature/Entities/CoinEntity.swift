//
//  CoinEntity.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Foundation

struct CoinEntity: Identifiable {
    let id: String
    let symbol: String
    let price: Double
    let date: Date
}

extension CoinEntity: Equatable {}
