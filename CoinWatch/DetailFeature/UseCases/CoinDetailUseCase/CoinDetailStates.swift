//
//  CoinDetailStates.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

enum CoinDetailStates: Equatable {
    case idle
    case loading
    case loaded(coins: [CoinDetailEntity])
    case error
}
