//
//  Registerar.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Resolver

extension Resolver: @retroactive ResolverRegistering {

    public static func registerAllServices() {
        Resolver.register(CoinListRepositoryProtocol.self) {
            CoinListRepositoryImpl()
        }
        .scope(.application)
        Resolver.register(CoinListUseCaseProtocol.self) {
            CoinListUseCaseImpl()
        }
        .scope(.application)
    }
}
