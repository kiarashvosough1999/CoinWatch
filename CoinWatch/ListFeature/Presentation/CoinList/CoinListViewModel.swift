//
//  CoinListViewModel.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Resolver
import Foundation

final class CoinListViewModel: ObservableObject {
    
    @LazyInjected private var listUseCase: CoinListUseCaseProtocol

    @Published private(set) var state: CoinListStates = .idle

    init() {
        listUseCase
            .statePublisher
            .assign(to: &$state)
        listUseCase.initialize()
    }
}
