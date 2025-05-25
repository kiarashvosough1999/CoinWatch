//
//  CoinDetailUseCaseRepositoryProtocol.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 25.05.25.
//

import Combine
import Foundation

protocol CoinDetailUseCaseRepositoryProtocol {
    func fetchDetail(
        for symbol: String,
        currencies: [String],
        on date: Date
    ) -> AnyPublisher<CoinDetailEntity, any Error>
}

struct CoinDetailUseCaseRepositoryStub: CoinDetailUseCaseRepositoryProtocol {

    let coin: CoinDetailEntity

    func fetchDetail(
        for symbol: String,
        currencies: [String],
        on date: Date
    ) -> AnyPublisher<CoinDetailEntity, any Error> {
        Future { yield in
            yield(
                .success(
                    CoinDetailEntity(
                        id: "id",
                        symbol: "bitcoin",
                        date: date,
                        prices: []
                    )
                )
            )
        }
        .eraseToAnyPublisher()
    }
}
