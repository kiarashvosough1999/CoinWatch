//
//  CoinListViewModelTests.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import XCTest
import Combine
import Resolver
@testable import CoinWatch

final class CoinListViewModelTests: XCTestCase {

    private var sut: CoinListViewModel!
    private var mockUseCase: MockCoinListUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockCoinListUseCase()
        Resolver.register(CoinListUseCaseProtocol.self) {
            self.mockUseCase
        }
        sut = CoinListViewModel()
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
            XCTFail("initial State shoud be Idle")
        }
    }
    
    func testStatePublisherEmitsLoadingAndLoaded() {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3

        var states: [CoinListStates] = []
        sut
            .$state
            .sink {
                states.append($0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockUseCase.send(.loading)

        let sampleCoins = [
            CoinEntity(id: "1", symbol: "BTC", currency: "EUR", price: 100, date: .now),
            CoinEntity(id: "2", symbol: "BTC", currency: "EUR", price: 200, date: .now.addingTimeInterval(3600 * 100))
        ]
        mockUseCase.send(.loaded(coins: sampleCoins))
        
        wait(for: [expectation], timeout: 2)
        
        for (index, state) in states.enumerated() {
            switch state {
            case .idle:
                XCTAssertEqual(index, 0, "Expected .idle at index 0")
            case .loading:
                XCTAssertEqual(index, 1, "Expected .loading at index 1")
            case .loaded(let coins):
                XCTAssertEqual(coins, sampleCoins, "Expected .loaded at index 2")
            case .error:
                XCTFail("Expected .loaded at index 2")
            }
        }
    }
    
    func testOnTapRetry_callsRetryAndEmitsErrorState() {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3

        var states: [CoinListStates] = []
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
        
        mockUseCase.send(.error(MockError.testFailure, retry: { retryExpectation.fulfill() }))
        
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
