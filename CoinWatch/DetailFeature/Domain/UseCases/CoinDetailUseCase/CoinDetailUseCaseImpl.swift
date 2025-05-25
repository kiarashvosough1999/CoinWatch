//
//  CoinDetailUseCaseImpl.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 25.05.25.
//

import Foundation
import Combine
import Resolver

final class CoinDetailUseCaseImpl {
    private let stateSubject = CurrentValueSubject<CoinDetailStates, Never>(.idle)
    private var cancellable: AnyCancellable?
}

extension CoinDetailUseCaseImpl: CoinDetailUseCaseProtocol {

    enum CoinDetailUseCaseError: LocalizedError {
        case invalidStateToReply
        case networkError
    }
    
    var statePublisher: AnyPublisher<CoinDetailStates, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    func initialize(date: Date) {
        cancellable = nil
        stateSubject.send(.loading)
        @LazyInjected var coinDetailUseCaseRepository: CoinDetailUseCaseRepositoryProtocol
        let InitialPublisher = coinDetailUseCaseRepository
            .fetchDetail(
                for: "bitcoin",
                currencies: ["EUR", "GBP", "USD"],
                on: date
            )

        let refreshPublisher = Timer
            .publish(every: 60, on: RunLoop.main, in: .common)
            .autoconnect()
            .flatMap { _ in
                InitialPublisher
            }
        
        let publisher = if Calendar.current.isDate(date, inSameDayAs: .now) {
            Publishers.Merge(InitialPublisher, refreshPublisher)
                .eraseToAnyPublisher()
        } else {
            InitialPublisher
                .eraseToAnyPublisher()
        }
        
        cancellable = publisher
            .sink { [weak stateSubject] completion in
                guard let stateSubject else { return }
                switch completion {
                case .finished:
                    break
                case .failure:
                    stateSubject.send(
                        .error(
                            error: CoinDetailUseCaseError.networkError,
                            retry: { [weak self] in
                                guard let self else { return }
                                initialize(date: date)
                            }
                        )
                    )
                }
            } receiveValue: { [weak stateSubject] coin in
                guard let stateSubject else { return }
                stateSubject.send(
                    .loaded(coin: coin)
                )
            }
    }
}
