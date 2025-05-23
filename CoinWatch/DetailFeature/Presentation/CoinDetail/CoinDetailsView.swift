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
                ErrorView(errorText: error.failureReason) {
                    viewModel.onTapRetry()
                }
            }
        }
    }

    private func coinDetail(_ coin: CoinDetailEntity) -> some View {
        List {
            CoinDetailView(coin: coin)
        }
        .listStyle(.grouped)
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
