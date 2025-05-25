//
//  CoinDetailViewModel.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import Foundation
import Resolver

final class CoinDetailViewModel: ObservableObject {

    @LazyInjected private var detailUseCase: CoinDetailUseCaseProtocol

    @Published private(set) var state: CoinDetailStates = .idle
    @Published private(set) var errorState: ErrorViewState?

    init(date: Date) {
        detailUseCase
            .statePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
        detailUseCase.initialize(date: date)
    }
}
