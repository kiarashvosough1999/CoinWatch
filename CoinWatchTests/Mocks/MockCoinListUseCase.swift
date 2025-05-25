//
//  MockCoinListUseCase.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import Combine
@testable import CoinWatch

final class MockCoinListUseCase: CoinListUseCaseProtocol {

    private let subject = PassthroughSubject<CoinListStates, Never>()

    var statePublisher: AnyPublisher<CoinListStates, Never> { subject.eraseToAnyPublisher() }

    func initialize() {}
    
    func send(_ state: CoinListStates) {
        subject.send(state)
    }
}
