//
//  CoinDetailUseCaseProtocol.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Combine

protocol CoinDetailUseCaseProtocol {

    var statePublisher: AnyPublisher<CoinDetailStates, Never> { get }

    func initialize()
}

enum CoinDetailStates: Equatable {
    case idle
    case loading
    case loaded(coins: [CoinDetailEntity])
    case error
}

