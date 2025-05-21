//
//  CoinListUseCaseProtocol.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Combine

protocol CoinListUseCaseProtocol {

    var statePublisher: AnyPublisher<CoinListStates, Never> { get }

    func initialize()
}

enum CoinListStates: Equatable {
    case idle
    case loading
    case loaded(coins: [CoinEntity])
    case error
}
