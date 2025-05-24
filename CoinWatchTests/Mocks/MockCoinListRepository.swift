//
//  MockCoinListRepository.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 24.05.25.
//

@testable import CoinWatch
import Combine

final class MockCoinListRepository: CoinListRepositoryProtocol {

    let subject = PassthroughSubject<[CoinEntity], Error>()

    private(set) var fetchCallCount = 0

    func fetchCoinList(
        coinName: String,
        dayInterval: UInt,
        currencyCode: String
    ) -> AnyPublisher<[CoinEntity], Error> {
        fetchCallCount += 1
        return subject.eraseToAnyPublisher()
    }
}
