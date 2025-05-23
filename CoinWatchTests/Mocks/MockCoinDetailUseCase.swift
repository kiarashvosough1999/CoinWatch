//
//  MockCoinDetailUseCase.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import XCTest
import Combine
@testable import CoinWatch

final class MockCoinDetailUseCase: CoinDetailUseCaseProtocol {

    private let subject = PassthroughSubject<CoinDetailStates, Never>()

    var statePublisher: AnyPublisher<CoinDetailStates, Never> { subject.eraseToAnyPublisher() }

    var retryCalled = false

    func initialize(date: Date) {}

    func retry() async throws {
        retryCalled = true
        throw MockError.testFailure
    }

    func send(_ state: CoinDetailStates) {
        subject.send(state)
    }
}
