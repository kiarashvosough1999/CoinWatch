//
//  CoinDetailViewModelTests.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import XCTest
import Combine
import Resolver
@testable import CoinWatch

final class CoinDetailViewModelTests: XCTestCase {

    private var sut: CoinDetailViewModel!
    private var mockUseCase: MockCoinDetailUseCase!
    private var cancellables: Set<AnyCancellable>!
    private let testDate = Date(timeIntervalSince1970: 1_000_000)

    override func setUp() {
        super.setUp()
        mockUseCase = MockCoinDetailUseCase()
        Resolver.register { self.mockUseCase as CoinDetailUseCaseProtocol }
        sut = CoinDetailViewModel(date: testDate)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        mockUseCase = nil
        Resolver.reset()
        super.tearDown()
    }

    func testInitialStateIsIdle() {
        switch sut.state {
        case .idle:
            break
        case .loading, .loaded, .error:
            XCTFail("Initial state should be .idle")
        }
    }

    func testStatePublisherEmitsLoadingAndLoaded() {
        let expectation = XCTestExpectation(description: "state updates")
        expectation.expectedFulfillmentCount = 3

        var states: [CoinDetailStates] = []
        sut
            .$state
            .sink { state in
                states.append(state)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Simulate loading and loaded
        mockUseCase.send(.loading)
        let sampleDetail = CoinDetailEntity(
            id: "1",
            symbol: "BTC",
            date: testDate,
            prices: []
        )
        mockUseCase.send(.loaded(coin: sampleDetail))

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(states.count, 3)
        
        for (index, state) in states.enumerated() {
            switch state {
            case .idle:
                XCTAssertEqual(index, 0, "Expected .idle at index 0")
            case .loading:
                XCTAssertEqual(index, 1, "Expected .loading at index 1")
            case .loaded(let coin):
                XCTAssertEqual(coin, sampleDetail, "Expected .loaded at index 2")
            case .error:
                XCTFail("Expected .loaded at index 2")
            }
        }
    }

    func testOnTapRetry_callsRetryAndEmitsErrorState() {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3

        var states: [CoinDetailStates] = []
        sut
            .$state
            .sink {
                states.append($0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockUseCase.send(.loading)
        
        let retryExpectation = XCTestExpectation()
        retryExpectation.expectedFulfillmentCount = 1
        
        mockUseCase.send(.error(error: MockError.testFailure, retry: { retryExpectation.fulfill() }))
        
        wait(for: [expectation], timeout: 2)
        
        for (index, state) in states.enumerated() {
            switch state {
            case .idle:
                XCTAssertEqual(index, 0, "Expected .idle at index 0")
            case .loading:
                XCTAssertEqual(index, 1, "Expected .loading at index 1")
            case .loaded:
                XCTFail("Expected .error at index 2")
            case .error(let error, let retry):
                let mockError = error as? MockError
                XCTAssertNotNil(mockError, "Expected .error at index 2")
                XCTAssertEqual(mockError, MockError.testFailure, "Expected .error at index 2")
                retry()
            }
        }
        
        wait(for: [retryExpectation], timeout: 2)
    }
}
