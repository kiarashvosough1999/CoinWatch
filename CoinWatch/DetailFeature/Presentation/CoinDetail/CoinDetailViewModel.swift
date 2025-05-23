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

    private let date: Date

    init(date: Date) {
        self.date = date
        detailUseCase.initialize(date: date)
    }

    func onTapRetry() {
        Task {
            do {
                try await detailUseCase.retry()
            } catch {
                
            }
        }
    }
}
