//
//  CoinDetailUseCaseImplTests.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 25.05.25.
//


import XCTest
import Combine
import Resolver
@testable import CoinWatch

final class CoinDetailUseCaseImplTests: XCTestCase {

    private var sut: CoinDetailUseCaseImpl!
    private var mockRepository: MockCoinDetailRepository!
    private var cancellables: Set<AnyCancellable>!
    private let testDate = Date(timeIntervalSince1970: 1_600_000_000)

    override func setUp() {
        super.setUp()
        mockRepository = MockCoinDetailRepository()
        Resolver.register { self.mockRepository as CoinDetailUseCaseRepositoryProtocol }
        sut = CoinDetailUseCaseImpl()
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
        let exp = expectation(description: "state updates: idle, loading, loaded")
        exp.expectedFulfillmentCount = 3
        var states: [CoinDetailStates] = []
        sut.statePublisher
            .sink { state in
                states.append(state)
                exp.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.initialize(date: testDate)
        let sampleDetail = CoinDetailEntity(
            id: "bitcoin",
            symbol: "BTC",
            date: testDate,
            prices: [
                CoinDetailEntity.Price(id: "EUR", price: 50000, currency: "EUR"),
                CoinDetailEntity.Price(id: "USD", price: 55000, currency: "USD"),
                CoinDetailEntity.Price(id: "GBP", price: 45000, currency: "GBP")
            ]
        )
        mockRepository.subject.send(sampleDetail)

        // Then
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(states.count, 3)
        // 0: idle
        if case .idle = states[0] {} else { XCTFail("Expected .idle at index 0") }
        // 1: loading
        if case .loading = states[1] {} else { XCTFail("Expected .loading at index 1") }
        // 2: loaded
        if case .loaded(let detail) = states[2] {
            XCTAssertEqual(detail, sampleDetail)
        } else {
            XCTFail("Expected .loaded at index 2")
        }
        // Ensure repository called once
        XCTAssertEqual(mockRepository.fetchCallCount, 1)
    }

    func testInitialize_onFailure_emitsErrorAndRetryInvokesFetchAgain() {
        // Given
        let exp = expectation(description: "state updates: idle, loading, error")
        exp.expectedFulfillmentCount = 5
        var receivedErrorState: CoinDetailStates?
        sut
            .statePublisher
            .sink { state in
                if case .error = state {
                    receivedErrorState = state
                }
                exp.fulfill()
                print(state)
            }
            .store(in: &cancellables)

        // When
        sut.initialize(date: testDate)
        mockRepository.subject.send(completion: .failure(MockError.networkError))

        // Then
        XCTAssertEqual(mockRepository.fetchCallCount, 1)
        // Validate error state and retry
        guard case .error(let error, let retry) = receivedErrorState else {
            XCTFail("Expected .error state"); return
        }
        XCTAssertTrue(error is CoinDetailUseCaseImpl.CoinDetailUseCaseError)

        // When retry is called
        retry()
        wait(for: [exp], timeout: 1)
        // Then fetch called again
        XCTAssertEqual(mockRepository.fetchCallCount, 2)
    }
}
