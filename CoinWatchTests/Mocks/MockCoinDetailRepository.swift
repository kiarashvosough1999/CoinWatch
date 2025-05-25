//
//  MockCoinDetailRepository.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 25.05.25.
//

import Combine
@testable import CoinWatch
import Foundation

final class MockCoinDetailRepository: CoinDetailUseCaseRepositoryProtocol {
    var subject = PassthroughSubject<CoinDetailEntity, Error>()
    private(set) var fetchCallCount = 0

    func fetchDetail(
        for coinName: String,
        currencies: [String],
        on date: Date
    ) -> AnyPublisher<CoinDetailEntity, Error> {
        fetchCallCount += 1
        return subject.eraseToAnyPublisher()
    }
}
