//
//  CoinListView.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import SwiftUI
import Resolver

struct CoinListView: View {

    @StateObject private var viewModel: CoinListViewModel = CoinListViewModel()

    var body: some View {
        ZStack(alignment: .center) {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let coins):
                coinList(coins)
            case .error(let error):
                ErrorView(state: .from(error, canRetry: true)) {
                    Task {
                        await viewModel.onTapRetry()
                    }
                }
            }
        }
        .overlay {
            errorView
        }
    }

    private func coinList(_ coins: [CoinEntity]) -> some View {
        List {
            ForEach(coins) { coin in
                NavigationLink(value: coin.date) {
                    CoinView(coin: coin)
                        .equatable()
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    @ViewBuilder
    private var errorView: some View {
        if let errorState = viewModel.errorState {
            ErrorView(state: errorState, onTapRetry: {})
        }
    }
}

#Preview {
    WithDepedencies {
        Resolver.register(CoinListUseCaseProtocol.self) {
            CoinListUseCaseStub(
                state: .loaded(
                    coins: stride(from: 0, to: 10, by: 1)
                        .map { index in
                            CoinEntity(
                                id: index.description,
                                symbol: "BTC",
                                price: .random(in: 100_000...200_200),
                                date: .now
                            )
                        }
                )
            )
        }
    } content: {
        CoinListView()
    }
}

