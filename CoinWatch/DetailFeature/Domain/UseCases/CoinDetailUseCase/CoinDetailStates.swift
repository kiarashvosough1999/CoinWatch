//
//  CoinDetailStates.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Foundation

enum CoinDetailStates {
    case idle
    case loading
    case loaded(coin: CoinDetailEntity)
    case error(error: LocalizedError, retry: () -> Void)
}
