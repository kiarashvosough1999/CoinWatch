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
        .listStyle(.grouped)
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
        Resolver.register(CoinListUseCaseProtocol.self) { (resolver: Resolver, args: Resolver.Args) in
            CoinListUseCaseStub(state: args())
        }
    } content: {
        CoinListView()
    }
}

