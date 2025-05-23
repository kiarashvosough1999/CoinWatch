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

    private func coinDetail(_ coin: CoinDetailEntity) -> some View {
        List {
            CoinDetailView(coin: coin)
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
        Resolver.register(CoinDetailUseCaseProtocol.self) { (resolver: Resolver, args: Resolver.Args) in
            CoinDetailUseCaseStub(state: args())
        }
    } content: {
        CoinDetailsView(date: .now)
    }
}
