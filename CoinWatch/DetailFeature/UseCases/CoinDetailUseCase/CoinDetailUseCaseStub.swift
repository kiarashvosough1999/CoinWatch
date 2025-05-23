//
//  CoinDetailUseCaseStub.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Combine
import Foundation

struct CoinDetailUseCaseStub {
    let state: CoinDetailStates
}

extension CoinDetailUseCaseStub: CoinDetailUseCaseProtocol {

    var statePublisher: AnyPublisher<CoinDetailStates, Never> { Just(state).eraseToAnyPublisher() }

    func initialize(date: Date) {}

    func retry() async throws {}
}
