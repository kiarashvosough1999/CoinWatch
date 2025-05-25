//
//  CoinListUseCaseImplTests.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 24.05.25.
//

import XCTest
import Combine
import Resolver
@testable import CoinWatch

final class CoinListUseCaseImplTests: XCTestCase {

    private var sut: CoinListUseCaseImpl!
    private var mockRepository: MockCoinListRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockCoinListRepository()
        Resolver.register { self.mockRepository as CoinListRepositoryProtocol }
        sut = CoinListUseCaseImpl()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        mockRepository = nil
        Resolver.reset()
        super.tearDown()
    }

    func testInitialize_emitsLoadingAndLoaded() {
        // Given
        let expectation = XCTestExpectation(description: "state updates: idle, loading, loaded")
        expectation.expectedFulfillmentCount = 3
        var states: [CoinListStates] = []
        sut.statePublisher
            .sink { state in
                states.append(state)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.initialize()
        let sampleCoins = [
            CoinEntity(id: "1", symbol: "BTC", currency: "EUR", price: 100, date: Date(timeIntervalSince1970: 1000)),
            CoinEntity(id: "2", symbol: "ETH", currency: "EUR", price: 200, date: Date(timeIntervalSince1970: 2000))
        ]
        mockRepository.subject.send(sampleCoins)

        // Then
        wait(for: [expectation], timeout: 1)
        let sorted = sampleCoins.sorted(by: { $0.date > $1.date })

        for (index, state) in states.enumerated() {
            switch state {
            case .idle:
                XCTAssertEqual(index, 0, "Expected .idle at index 0")
            case .loading:
                XCTAssertEqual(index, 1, "Expected .loading at index 1")
            case .loaded(let coin):
                XCTAssertEqual(coin, sorted, "Expected .loaded at index 2")
            case .error:
                XCTFail("Expected .loaded at index 2")
            }
        }
    }

    func testInitialize_failureEmitsErrorAndRetryInvokesFetchAgain() {
        // Given
        let expectation = XCTestExpectation(description: "state updates: idle, loading, error")
        expectation.expectedFulfillmentCount = 3
        var receivedErrorState: CoinListStates?
        sut.statePublisher
            .sink { state in
                if case .error = state {
                    receivedErrorState = state
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.initialize()
        mockRepository.subject.send(completion: .failure(MockError.networkError))

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(mockRepository.fetchCallCount, 1)

        guard case .error(let localizedError, let retry) = receivedErrorState else {
            XCTFail("Expected .error state"); return
        }
        XCTAssertTrue(localizedError is CoinListUseCaseImpl.CoinListUseCaseError)

        retry()

        XCTAssertEqual(mockRepository.fetchCallCount, 2)
    }
}
