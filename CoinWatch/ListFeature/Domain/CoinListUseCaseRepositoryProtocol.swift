//
//  CoinListUseCaseRepositoryProtocol.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import Combine

protocol CoinListRepositoryProtocol {
    func fetchCoinList(
        coinName: String,
        dayInterval: UInt,
        currencyCode: String
    ) -> AnyPublisher<[CoinEntity], Error>
}

struct CoinListRepositoryStub: CoinListRepositoryProtocol {
    
    let coins: [CoinEntity]

    func fetchCoinList(
        coinName: String,
        dayInterval: UInt,
        currencyCode: String
    ) -> AnyPublisher<[CoinEntity], any Error> {
        Future { yield in
            yield(.success(coins))
        }
        .eraseToAnyPublisher()
    }
}
