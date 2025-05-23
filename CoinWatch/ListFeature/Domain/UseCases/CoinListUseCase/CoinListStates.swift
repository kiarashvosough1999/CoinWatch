//
//  CoinListStates.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Foundation

enum CoinListStates {
    case idle
    case loading
    case loaded(coins: [CoinEntity])
    case error(LocalizedError, retry: () -> Void)
}
