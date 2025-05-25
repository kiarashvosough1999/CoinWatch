//
//  CoinDetailsView.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import SwiftUI
import Resolver

struct CoinDetailsView: View {

    @StateObject private var viewModel: CoinDetailViewModel

    init(date: Date) {
        self._viewModel = StateObject(wrappedValue: CoinDetailViewModel(date: date))
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let coin):
                coinDetail(coin)
            case .error(let error, let retry):
                ErrorView(state: .from(error, canRetry: true), onTapRetry: retry)
            }
        }
    }

    private func coinDetail(_ coin: CoinDetailEntity) -> some View {
        List {
            CoinDetailView(coin: coin)
        }
        .listStyle(.insetGrouped)
    }
}

#Preview {
    WithDepedencies {
        Resolver.register(CoinDetailUseCaseProtocol.self) {
            CoinDetailUseCaseStub(
                state: .loaded(
                    coin: CoinDetailEntity(
                        id: "bitcoin",
                        symbol: "btc",
                        date: .now,
                        prices: stride(from: 0, to: 3, by: 1)
                            .map { index in
                                CoinDetailEntity.Price(
                                    id: index.description,
                                    price: index,
                                    currency: "usd"
                                )
                            }
                    )
                )
            )
        }
    } content: {
        CoinDetailsView(date: .now)
    }
}
