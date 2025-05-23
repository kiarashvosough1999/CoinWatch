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

    private var viewModel: CoinDetailViewModel!
    private var mockUseCase: MockCoinDetailUseCase!
    private var cancellables: Set<AnyCancellable>!
    private let testDate = Date(timeIntervalSince1970: 1_000_000)

    override func setUp() {
        super.setUp()
        mockUseCase = MockCoinDetailUseCase()
        Resolver.register { self.mockUseCase as CoinDetailUseCaseProtocol }
        viewModel = CoinDetailViewModel(date: testDate)
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
            XCTFail("Initial state should be .idle")
        }
    }

    func testStatePublisherEmitsLoadingAndLoaded() {
        let expectation = XCTestExpectation(description: "state updates")
        expectation.expectedFulfillmentCount = 3

        var states: [CoinDetailStates] = []
        viewModel
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

    func testOnTapRetry_callsRetryAndEmitsErrorState() async {
        var receivedErrorState: ErrorViewState?
        viewModel
            .$errorState
            .compactMap { $0 }
            .sink { receivedErrorState = $0 }
            .store(in: &cancellables)

        await viewModel.onTapRetry()

        XCTAssertTrue(mockUseCase.retryCalled)
        XCTAssertEqual(receivedErrorState, .custom(MockError.testFailure.failureReason!, canRetry: false))
    }
}
