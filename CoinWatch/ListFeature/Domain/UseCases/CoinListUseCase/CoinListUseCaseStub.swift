//
//  CoinListUseCaseStub.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Combine

struct CoinListUseCaseStub {
    let state: CoinListStates
}

extension CoinListUseCaseStub: CoinListUseCaseProtocol {

    var statePublisher: AnyPublisher<CoinListStates, Never> { Just(state).eraseToAnyPublisher() }

    func initialize() {}
    
    func retry() async throws {}
}
