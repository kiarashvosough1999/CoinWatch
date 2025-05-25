//
//  Registerar.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Resolver
import Foundation

extension Resolver: @retroactive ResolverRegistering {

    public static func registerAllServices() {
        guard
            NSClassFromString("XCTestCase") == nil,
            ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1"
        else { return }
        Resolver.register(CoinListRepositoryProtocol.self) {
            CoinListRepositoryImpl()
        }
        .scope(.application)
        Resolver.register(CoinListUseCaseProtocol.self) {
            CoinListUseCaseImpl()
        }
        .scope(.application)
        Resolver.register(CoinDetailUseCaseProtocol.self) {
            CoinDetailUseCaseImpl()
        }
        .scope(.application)

        Resolver.register(CoinDetailUseCaseRepositoryProtocol.self) {
            CoinDetailRepositoryImpl()
        }
        .scope(.application)
    }
}
