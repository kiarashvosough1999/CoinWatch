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

    private var viewModel: CoinListViewModel!
    private var mockUseCase: MockCoinListUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockCoinListUseCase()
        Resolver.register(CoinListUseCaseProtocol.self) {
            self.mockUseCase
        }
        viewModel = CoinListViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockUseCase = nil
        Resolver.reset()
        super.tearDown()
    }
    
    func testInitialStateIsIdle() {
        switch viewModel.state {
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
        viewModel
            .$state
            .sink {
                states.append($0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockUseCase.send(.loading)

        let sampleCoins = [
            CoinEntity(id: "1", symbol: "BTC", price: 100, date: .now),
            CoinEntity(id: "2", symbol: "BTC", price: 200, date: .now.addingTimeInterval(3600 * 100))
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
    
    func testOnTapRetry_callsRetryAndEmitsErrorState() async {
        var receivedErrorState: ErrorViewState?
        viewModel
            .$errorState
            .compactMap { $0 }
            .sink {
                receivedErrorState = $0
            }
            .store(in: &cancellables)
        
        await viewModel.onTapRetry()
        
        XCTAssertTrue(mockUseCase.retryCalled)
        XCTAssertEqual(receivedErrorState, .custom(MockError.testFailure.failureReason!, canRetry: false))
    }
}
