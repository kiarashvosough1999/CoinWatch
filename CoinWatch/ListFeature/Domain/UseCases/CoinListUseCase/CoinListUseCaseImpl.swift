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
                            CoinListUseCaseError.networkError
                        )
                    )
                }
            } receiveValue: { [weak stateSubject] _ in
                guard let stateSubject else { return }
                stateSubject.send(.idle)
            }
    }

    func retry() async throws {
        let stream = statePublisher
            .timeout(
                .seconds(2),
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .values

        for try await state in stream {
            switch state {
            case .idle, .loading, .loaded:
                throw CoinListUseCaseError.invalidStateToReply
            case .error:
                initialize()
            }
        }
    }
}
