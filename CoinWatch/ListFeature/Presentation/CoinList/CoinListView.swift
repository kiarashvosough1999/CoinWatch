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
                ErrorView(errorText: error.failureReason) {
                    viewModel.onTapRetry()
                }
            }
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

