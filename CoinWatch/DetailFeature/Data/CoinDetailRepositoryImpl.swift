//
//  CoinDetailRepositoryImpl.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 25.05.25.
//

import Combine
import Foundation

final class CoinDetailRepositoryImpl {
    
}

extension CoinDetailRepositoryImpl: CoinDetailUseCaseRepositoryProtocol {

    enum Errors: LocalizedError {
        case invalidParameters
        case invalidResponse
        case invalidToken
    }

    func fetchDetail(
        for symbol: String,
        currencies: [String],
        on date: Date
    ) -> AnyPublisher<CoinDetailEntity, any Error> {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "API_CLIENT_Token") as? String else {
            return Fail(error: Errors.invalidToken)
                .eraseToAnyPublisher()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let dateString = dateFormatter.string(from: date)

        var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/bitcoin/history")
        components?.queryItems = [
            URLQueryItem(name: "date", value: dateString),
            URLQueryItem(name: "localization", value: "false"),
            URLQueryItem(name: "x-cg-api-key", value: token)
        ]

        guard let url = components?.url else {
            return Fail(error: Errors.invalidParameters)
                .eraseToAnyPublisher()
        }

        struct History: Codable {
            let id, symbol, name: String
            let marketData: MarketData

            enum CodingKeys: String, CodingKey {
                case id, symbol, name
                case marketData = "market_data"
            }
        }

        struct MarketData: Codable {
            let currentPrice: [String: Double]

            enum CodingKeys: String, CodingKey {
                case currentPrice = "current_price"
            }
        }

        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { (data, _) in
                try JSONDecoder().decode(History.self, from: data)
            }
            .tryMap { history in
                CoinDetailEntity(
                    id: history.id,
                    symbol: history.symbol,
                    date: date,
                    prices: history
                        .marketData
                        .currentPrice
                        .filter { (key, _) in
                            currencies
                                .map { $0.lowercased() }
                                .contains(key)
                        }
                        .map { (key, value) in
                            CoinDetailEntity.Price(
                                id: key,
                                price: value,
                                currency: key
                            )
                        }
                )
            }
            .eraseToAnyPublisher()
    }
}
