//
//  CoinListUseCaseImpl.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import Combine
import Dispatch
import Foundation
import Resolver

final class CoinListUseCaseImpl {
    private let stateSubject = CurrentValueSubject<CoinListStates, Never>(.idle)
    private var cancellable: AnyCancellable?
}

// MARK: - CoinListUseCaseProtocol

extension CoinListUseCaseImpl: CoinListUseCaseProtocol {

    enum CoinListUseCaseError: LocalizedError {
        case invalidStateToReply
        case networkError
    }

    var statePublisher: AnyPublisher<CoinListStates, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    func initialize() {
        stateSubject.send(.loading)
        cancellable = Timer
            .publish(every: 60, on: RunLoop.main, in: .common)
            .autoconnect()
            .flatMap { _ in
                @LazyInjected var coinListRepository: CoinListRepositoryProtocol
                return coinListRepository
                    .fetchCoinList(
                        coinName: "bitcoin",
                        dayInterval: 14,
                        currencyCode: "eur"
                    )
            }
            .sink { [weak stateSubject] completion in
                guard let stateSubject else { return }
                switch completion {
                case .finished:
                    stateSubject.send(.idle)
                case .failure:
                    stateSubject.send(
                        .error(
                            CoinListUseCaseError.networkError,
                            retry: { [weak self] in
                                guard let self else { return }
                                initialize()
                            }
                        )
                    )
                }
            } receiveValue: { [weak stateSubject] coins in
                guard let stateSubject else { return }
                stateSubject.send(
                    .loaded(
                        coins: coins
                    )
                )
            }
    }
}
