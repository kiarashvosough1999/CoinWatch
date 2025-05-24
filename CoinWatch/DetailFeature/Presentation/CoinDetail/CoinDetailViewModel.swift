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

    private let date: Date

    init(date: Date) {
        self.date = date
        detailUseCase
            .statePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
        detailUseCase.initialize(date: date)
    }

    func onTapRetry() async {
        do {
            try await Task.detached(priority: .userInitiated) {
                @LazyInjected var detailUseCase: CoinDetailUseCaseProtocol
                try await detailUseCase.retry()
            }.value
        } catch let error as LocalizedError {
            errorState = .from(error)
        } catch {
            errorState = .generic()
        }
    }
}
