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
        @LazyInjected var coinListRepository: CoinListRepositoryProtocol
        let InitialPublisher = coinListRepository
            .fetchCoinList(
                coinName: "bitcoin",
                dayInterval: 14,
                currencyCode: "EUR"
            )
        
         let refreshPublisher = Timer
            .publish(every: 60, on: RunLoop.main, in: .common)
            .autoconnect()
            .flatMap { _ in
                InitialPublisher
            }
        cancellable = Publishers.Merge(InitialPublisher, refreshPublisher)
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
                        coins: coins.sorted(by: { $0.date > $1.date })
                    )
                )
            }
    }
}
