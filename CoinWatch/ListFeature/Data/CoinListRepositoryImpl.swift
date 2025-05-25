//
//  CoinListRepositoryImpl.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import Foundation
import Combine

final class CoinListRepositoryImpl {
    
}

extension CoinListRepositoryImpl: CoinListRepositoryProtocol {

    enum Errors: LocalizedError {
        case invalidParameters
        case invalidToken
    }

    func fetchCoinList(
        coinName: String,
        dayInterval: UInt,
        currencyCode: String
    ) -> AnyPublisher<[CoinEntity], any Error> {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "API_CLIENT_Token") as? String else {
            return Fail(error: Errors.invalidToken)
                .eraseToAnyPublisher()
        }
        let url = URL(
            string: "https://api.coingecko.com/api/v3/coins/\(coinName)/market_chart?vs_currency=\(currencyCode)&days=\(dayInterval)&interval=daily&x-cg-api-key=\(token)"
        )
        guard let url else {
            return Fail(error: Errors.invalidParameters)
                .eraseToAnyPublisher()
        }

        struct Coin: Codable {
            let prices: [[Double]]
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { (data: Data, _) in
                try JSONDecoder().decode(Coin.self, from: data)
            }
            .map { coins in
                coins.prices.compactMap { coin -> CoinEntity? in
                    guard let time = coin.first, let price = coin.last else { return nil }
                    return CoinEntity(
                        id: time.description,
                        symbol: coinName,
                        currency: currencyCode,
                        price: price,
                        date: Date(timeIntervalSince1970: TimeInterval(time) / 1_000)
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
