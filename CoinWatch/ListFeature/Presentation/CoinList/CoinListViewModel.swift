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
    @Published private(set) var errorState: ErrorViewState?

    init() {
        listUseCase
            .statePublisher
            .assign(to: &$state)
        listUseCase.initialize()
    }

    func onTapRetry() async {
        do {
            try await Task.detached(priority: .userInitiated) {
                @LazyInjected var listUseCase: CoinListUseCaseProtocol
                try await listUseCase.retry()
            }.value
        } catch let error as LocalizedError {
            errorState = .from(error)
        } catch {
            errorState = .generic()
        }
    }
}
