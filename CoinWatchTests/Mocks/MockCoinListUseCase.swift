//
//  MockCoinListUseCase.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import XCTest
import Combine
@testable import CoinWatch

final class MockCoinListUseCase: CoinListUseCaseProtocol {

    private let subject = PassthroughSubject<CoinListStates, Never>()

    var statePublisher: AnyPublisher<CoinListStates, Never> { subject.eraseToAnyPublisher() }

    var retryCalled = false

    
    func initialize() {}
    
    func retry() async throws {
        retryCalled = true
        throw MockError.testFailure
    }
    
    func send(_ state: CoinListStates) {
        subject.send(state)
    }
}
