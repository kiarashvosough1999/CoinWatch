//
//  CoinListStates.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

enum CoinListStates: Equatable {
    case idle
    case loading
    case loaded(coins: [CoinEntity])
    case error
}
